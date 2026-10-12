import 'package:flutter/foundation.dart';

/// Konfigurasi runtime. Override lewat `--dart-define`, contoh:
/// `flutter run --dart-define=API_BASE_URL=https://api.example.com`
abstract final class Env {
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://jsonplaceholder.typicode.com',
  );

  static const bool isDebug = kDebugMode;
}
