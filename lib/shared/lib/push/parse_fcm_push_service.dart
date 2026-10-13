import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:path_provider/path_provider.dart';

import '../../config/app_info.dart';
import '../../config/env.dart';
import '../logging/app_logger.dart';
import 'push_service.dart';

/// Push lewat Parse Server + Firebase Cloud Messaging.
///
/// - Token FCM didaftarkan sebagai `_Installation` di Parse (`deviceToken`,
///   `pushType: gcm`, `GCMSenderId`, dan `userId` saat masuk) sehingga server
///   bisa mengirim ke semua perangkat atau ke user tertentu.
/// - Firebase diinisialisasi dari `FIREBASE_*` di `env/*.json`, tanpa
///   `google-services.json`.
/// - Pesan saat app di depan ditampilkan lewat [LocalPushService]; tap
///   notifikasi (foreground, background, maupun saat app tertutup) memanggil
///   `onOpened` dengan `route` dari data pesan.
class ParseFcmPushService implements PushService {
  ParseFcmPushService({required this._local});

  final LocalPushService _local;
  final _messages = StreamController<PushMessage>.broadcast();
  final _log = log('push.parse');
  String? _userId;
  bool _enabled = false;

  @override
  Future<void> initialize({
    required void Function(PushMessage message) onOpened,
  }) async {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: Env.firebaseApiKey,
        appId: Env.firebaseAppId,
        messagingSenderId: Env.firebaseSenderId,
        projectId: Env.firebaseProjectId,
      ),
    );
    final dir = await getApplicationSupportDirectory();
    await Parse().initialize(
      Env.parseAppId,
      Env.parseServerUrl,
      clientKey: Env.parseClientKey.isEmpty ? null : Env.parseClientKey,
      appName: AppInfo.name,
      // `debug` sengaja tidak dinyalakan: SDK mencetak kunci dan body ke log.
      coreStore: await CoreStoreSembastImp.getInstance('${dir.path}/parse'),
    );
    await _local.initialize(onOpened: onOpened);

    FirebaseMessaging.onBackgroundMessage(parseFcmBackgroundHandler);
    final messaging = FirebaseMessaging.instance;
    // Token baru didaftarkan oleh [setEnabled] sesuai preferensi user.
    messaging.onTokenRefresh.listen((token) {
      if (_enabled) unawaited(_register(token));
    });
    FirebaseMessaging.onMessage.listen((m) {
      _log.info('onMessage id=${m.messageId} data=${m.data}');
      _messages.add(toPushMessage(m));
    });
    FirebaseMessaging.onMessageOpenedApp.listen(
      (m) => onOpened(toPushMessage(m)),
    );
    final initial = await messaging.getInitialMessage();
    if (initial != null) onOpened(toPushMessage(initial));
    _log.info('FCM siap, Parse ${Env.parseServerUrl}');
  }

  @override
  Future<String?> token() => FirebaseMessaging.instance.getToken();

  @override
  Stream<PushMessage> get onMessage => _messages.stream;

  @override
  Future<void> showLocal(PushMessage message) => _local.showLocal(message);

  @override
  Future<void> identify(String? userId) async {
    _userId = userId;
    if (_enabled) await _register(await FirebaseMessaging.instance.getToken());
  }

  @override
  Future<void> setEnabled(bool enabled) async {
    _enabled = enabled;
    final messaging = FirebaseMessaging.instance;
    if (enabled) {
      await _register(await messaging.getToken());
      return;
    }
    // Cabut dari dua sisi: token FCM dihapus dan deviceToken di Parse dikosongkan.
    try {
      await messaging.deleteToken();
    } on Object catch (e) {
      _log.warning('deleteToken gagal', e);
    }
    try {
      final installation = await ParseInstallation.currentInstallation();
      if (installation.objectId == null) return; // belum pernah terdaftar
      // Parse menolak op Delete pada deviceToken (tipe String), tetapi
      // menerima null; nilai null mengeluarkan installation dari target push.
      installation.deviceToken = null;
      final response = await installation.save();
      if (response.success) {
        _log.info('deviceToken dicabut dari Parse');
      } else {
        _log.warning('gagal mencabut deviceToken: ${response.error?.message}');
      }
    } on Object catch (e, st) {
      _log.warning('gagal mencabut deviceToken', e, st);
    }
  }

  Future<void> _register(String? token) async {
    if (token == null) return;
    try {
      final installation = await ParseInstallation.currentInstallation();
      installation
        ..deviceToken = token
        ..set<String>('pushType', 'gcm')
        ..set<String>('GCMSenderId', Env.firebaseSenderId)
        ..set<String?>('userId', _userId)
        ..set<String>('appIdentifier', AppInfo.name);
      final response = await installation.save();
      if (!response.success) {
        _log.warning(
          'gagal menyimpan installation: ${response.error?.message}',
        );
      }
    } on Exception catch (e, st) {
      _log.warning('gagal mendaftarkan token', e, st);
    }
  }

  /// Parse mengirim payload sebagai JSON string di `data['data']`
  /// (`{"title":..,"alert":..,"route":..}`); FCM biasa menaruh field langsung
  /// di `data` atau `notification`. Semuanya didukung.
  static PushMessage toPushMessage(RemoteMessage m) {
    final data = <String, String>{
      for (final e in m.data.entries) e.key: e.value.toString(),
    };
    final nested = data['data'];
    if (nested != null && nested.trimLeft().startsWith('{')) {
      try {
        final parsed = jsonDecode(nested) as Map<String, dynamic>;
        for (final e in parsed.entries) {
          data.putIfAbsent(e.key, e.value.toString);
        }
      } on FormatException {
        // bukan JSON, biarkan apa adanya
      }
    }
    return PushMessage(
      title: m.notification?.title ?? data['title'],
      body: m.notification?.body ?? data['alert'] ?? data['body'],
      route: data['route'] ?? data['uri'],
      data: data,
    );
  }
}

/// Dipanggil di isolate terpisah saat pesan datang dan app di background.
/// Pesan data-only (gaya Parse) ditampilkan sebagai notifikasi lokal;
/// pesan dengan `notification` sudah ditampilkan sistem.
@pragma('vm:entry-point')
Future<void> parseFcmBackgroundHandler(RemoteMessage message) async {
  debugPrint(
    '[push.parse] background message data=${message.data} '
    'notif=${message.notification?.title}',
  );
  if (message.notification != null) return;
  final push = ParseFcmPushService.toPushMessage(message);
  if (push.title == null && push.body == null) return;
  try {
    final local = LocalPushService(
      channelName: 'General',
      channelDescription: 'General app notifications',
    );
    await local.initialize(onOpened: (_) {});
    await local.showLocal(push);
    debugPrint('[push.parse] background shown: ${push.title}');
  } on Object catch (e, st) {
    debugPrint('[push.parse] background gagal: $e\n$st');
  }
}
