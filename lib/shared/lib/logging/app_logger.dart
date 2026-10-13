import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

/// Logger bernama per area, contoh: `final _log = log('sign_in');`.
Logger log(String name) => Logger(name);

/// Pasang sekali di bootstrap. Output lewat [debugPrint] agar aman di
/// release dan terpotong rapi di Android logcat.
void setupLogging({required String level}) {
  Logger.root
    ..level = _parseLevel(level)
    ..onRecord.listen((record) {
      final buffer = StringBuffer(
        '[${record.level.name}] ${record.loggerName}: ${record.message}',
      );
      if (record.error != null) buffer.write('\n  error: ${record.error}');
      if (record.stackTrace != null) buffer.write('\n${record.stackTrace}');
      debugPrint(buffer.toString());
    });
}

Level _parseLevel(String name) => Level.LEVELS.firstWhere(
      (l) => l.name == name.toUpperCase(),
      orElse: () => Level.ALL,
    );
