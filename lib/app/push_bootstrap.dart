import 'package:droid/shared/lib/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';

/// Menghubungkan [PushService] ke router: ketukan notifikasi membuka
/// `message.route`, pesan foreground ditampilkan sebagai notifikasi lokal.
/// Di-watch sekali oleh [App].
final pushBootstrapProvider = FutureProvider<void>((ref) async {
  final push = ref.watch(pushServiceProvider);
  final router = ref.watch(appRouterProvider);
  final log = ref.read(crashReporterProvider);

  await push.initialize(
    onOpened: (message) {
      final route = message.route;
      if (route != null && route.isNotEmpty) router.go(route);
    },
  );

  final sub = push.onMessage.listen(
    push.showLocal,
    onError: (Object e, StackTrace st) {
      log.record(e, st);
    },
  );
  ref.onDispose(sub.cancel);
});
