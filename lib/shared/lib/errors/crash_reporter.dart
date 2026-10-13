import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logging/app_logger.dart';

/// Tujuan laporan error. Default hanya mencatat ke log; ganti dengan
/// Sentry/Crashlytics lewat `crashReporterProvider.overrideWithValue(...)`
/// di `main.dart`.
abstract interface class CrashReporter {
  Future<void> record(Object error, StackTrace? stackTrace, {bool fatal});
  Future<void> setUser(String? id);
}

class LogCrashReporter implements CrashReporter {
  LogCrashReporter();

  final _log = log('crash');

  @override
  Future<void> record(
    Object error,
    StackTrace? stackTrace, {
    bool fatal = false,
  }) async {
    _log.severe(fatal ? 'FATAL' : 'error', error, stackTrace);
  }

  @override
  Future<void> setUser(String? id) async => _log.fine('user=$id');
}

final crashReporterProvider = Provider<CrashReporter>(
  (_) => LogCrashReporter(),
);
