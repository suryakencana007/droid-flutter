import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logging/app_logger.dart';

/// Pesan push yang sudah dinormalisasi dari sumber mana pun (FCM, lokal).
class PushMessage {
  const PushMessage({this.title, this.body, this.route, this.data = const {}});

  final String? title;
  final String? body;

  /// Route app yang dibuka saat notifikasi diketuk, contoh `/notes/12`.
  final String? route;
  final Map<String, String> data;
}

/// Sumber notifikasi. Implementasi bawaan hanya notifikasi lokal; untuk FCM
/// buat `FirebasePushService` dan override `pushServiceProvider`
/// (lihat docs/push.md).
abstract interface class PushService {
  /// Dipanggil sekali saat app mulai. [onOpened] dipanggil saat user mengetuk
  /// notifikasi, termasuk yang membuka app dari keadaan tertutup.
  Future<void> initialize({
    required void Function(PushMessage message) onOpened,
  });

  /// Token perangkat untuk dikirim ke server; `null` bila tidak ada (lokal).
  Future<String?> token();

  /// Pesan yang datang saat app di depan.
  Stream<PushMessage> get onMessage;

  /// Tampilkan notifikasi sekarang (dipakai untuk pesan foreground dan uji).
  Future<void> showLocal(PushMessage message);
}

class LocalPushService implements PushService {
  LocalPushService({
    required this.channelName,
    required this.channelDescription,
    FlutterLocalNotificationsPlugin? plugin,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const channelId = 'default';

  final String channelName;
  final String channelDescription;
  final FlutterLocalNotificationsPlugin _plugin;
  final _messages = StreamController<PushMessage>.broadcast();
  final _log = log('push');
  var _nextId = 1;

  @override
  Future<void> initialize({
    required void Function(PushMessage message) onOpened,
  }) async {
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (response) =>
          onOpened(PushMessage(route: response.payload)),
    );
    final launch = await _plugin.getNotificationAppLaunchDetails();
    final payload = launch?.notificationResponse?.payload;
    if (launch?.didNotificationLaunchApp ?? false) {
      onOpened(PushMessage(route: payload));
    }
    _log.fine('local notifications ready');
  }

  @override
  Future<String?> token() async => null;

  @override
  Stream<PushMessage> get onMessage => _messages.stream;

  @override
  Future<void> showLocal(PushMessage message) async {
    await _plugin.show(
      id: _nextId++,
      title: message.title,
      body: message.body,
      payload: message.route,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }
}

class NoopPushService implements PushService {
  const NoopPushService();

  @override
  Future<void> initialize({
    required void Function(PushMessage) onOpened,
  }) async {}

  @override
  Future<String?> token() async => null;

  @override
  Stream<PushMessage> get onMessage => const Stream.empty();

  @override
  Future<void> showLocal(PushMessage message) async {}
}

/// Untuk test: menyimpan notifikasi yang ditampilkan dan bisa mensimulasikan
/// ketukan lewat [open].
class MemoryPushService implements PushService {
  final shown = <PushMessage>[];
  final _messages = StreamController<PushMessage>.broadcast();
  void Function(PushMessage)? _onOpened;

  @override
  Future<void> initialize({
    required void Function(PushMessage) onOpened,
  }) async {
    _onOpened = onOpened;
  }

  @override
  Future<String?> token() async => 'memory-token';

  @override
  Stream<PushMessage> get onMessage => _messages.stream;

  @override
  Future<void> showLocal(PushMessage message) async => shown.add(message);

  void open(PushMessage message) => _onOpened?.call(message);

  void receive(PushMessage message) => _messages.add(message);
}

/// Nama channel diisi di `app` dari l10n karena shared tidak punya context.
final pushServiceProvider = Provider<PushService>(
  (_) => LocalPushService(
    channelName: 'General',
    channelDescription: 'General app notifications',
  ),
);
