import 'package:droid/features/manage_notifications/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';

/// Menghubungkan [PushService] ke router: ketukan notifikasi membuka
/// `message.route`, pesan foreground ditampilkan sebagai notifikasi lokal.
/// Di-watch sekali oleh [App].
final pushBootstrapProvider = FutureProvider<void>((ref) async {
  final push = ref.watch(pushServiceProvider);
  final router = ref.watch(appRouterProvider);
  final reporter = ref.read(crashReporterProvider);
  final logger = log('push');

  await push.initialize(
    onOpened: (message) {
      final route = message.route;
      if (route != null && route.isNotEmpty) router.go(route);
    },
  );

  // Preferensi user menentukan pendaftaran token di server.
  final enabled = await ref.read(notificationsEnabledProvider.future);
  await push.setEnabled(enabled);
  ref.listen(notificationsEnabledProvider, (_, next) {
    final value = next.value;
    if (value != null) push.setEnabled(value);
  });

  final sub = push.onMessage.listen(
    (message) async {
      if (ref.read(notificationsEnabledProvider).value != true) {
        logger.info('diabaikan (notifikasi dimatikan): ${message.title}');
        return;
      }
      logger.info('menampilkan: ${message.title}');
      try {
        await push.showLocal(message);
      } on Object catch (e, st) {
        logger.warning('gagal menampilkan', e, st);
        await reporter.record(e, st);
      }
    },
    onError: (Object e, StackTrace st) {
      reporter.record(e, st);
    },
  );
  ref.onDispose(sub.cancel);
});
