import 'dart:ui';

import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'app.dart';

/// Titik masuk: logging, penangkap error global, lalu [runApp].
///
/// Beri [container] sendiri dari `main.dart` untuk menukar implementasi,
/// misalnya:
/// ```dart
/// bootstrap(
///   container: ProviderContainer(
///     overrides: [crashReporterProvider.overrideWithValue(SentryReporter())],
///     observers: [AppProviderObserver()],
///   ),
/// );
/// ```
Future<void> bootstrap({ProviderContainer? container}) async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLogging(level: Env.logLevel);

  container ??= ProviderContainer(observers: [AppProviderObserver()]);
  final reporter = container.read(crashReporterProvider);

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    reporter.record(details.exception, details.stack, fatal: true);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    reporter.record(error, stack, fatal: true);
    return true;
  };
  if (!kDebugMode) {
    ErrorWidget.builder = (details) => const _FriendlyErrorWidget();
  }

  log('bootstrap').info('flavor=${Env.flavor.name} api=${Env.apiBaseUrl}');

  runApp(
    UncontrolledProviderScope(container: container, child: const App()),
  );
}

/// Meneruskan error provider ke [CrashReporter].
final class AppProviderObserver extends ProviderObserver {
  final _log = log('riverpod');

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    _log.warning('${context.provider} failed', error, stackTrace);
    context.container.read(crashReporterProvider).record(error, stackTrace);
  }
}

/// Pengganti layar merah di build non-debug.
class _FriendlyErrorWidget extends StatelessWidget {
  const _FriendlyErrorWidget();

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Terjadi kesalahan pada tampilan ini.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
