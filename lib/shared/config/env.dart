import 'package:flutter/foundation.dart';

enum AppFlavor { dev, staging, prod }

/// Konfigurasi runtime dari `--dart-define-from-file=env/<flavor>.json`
/// (lihat `env/` dan recipe `just env=staging run`). Tanpa define, nilainya
/// setara `env/dev.json` supaya `flutter run` polos tetap jalan.
abstract final class Env {
  static const _env = String.fromEnvironment('APP_ENV', defaultValue: 'dev');

  static final AppFlavor flavor = AppFlavor.values.firstWhere(
    (f) => f.name == _env,
    orElse: () => AppFlavor.dev,
  );

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  /// Pakai implementasi API in-memory (`FakeAuthApi`, dst.) alih-alih HTTP.
  static const useFakeApi = bool.fromEnvironment(
    'USE_FAKE_API',
    defaultValue: true,
  );

  /// Nama level `package:logging`: ALL, FINE, INFO, WARNING, SEVERE, OFF.
  static const logLevel = String.fromEnvironment(
    'LOG_LEVEL',
    defaultValue: 'ALL',
  );

  /// Environment key Flagsmith; kosong = pakai [featureFlags] lokal.
  static const flagsmithEnvKey = String.fromEnvironment('FLAGSMITH_ENV_KEY');

  /// Flag lokal, format `nama:nilai;nama2:nilai2`. Nilai `true`/`false`
  /// berarti aktif/nonaktif; nilai lain dianggap aktif dengan value itu.
  static const featureFlags = String.fromEnvironment(
    'FEATURE_FLAGS',
    defaultValue: 'notes_create_enabled:true;beta_badge:true',
  );

  // ---------- Parse Server (push lewat FCM, opsional backend) ----------
  static const parseServerUrl = String.fromEnvironment(
    'PARSE_SERVER_URL',
    defaultValue: 'https://parse.kubus.work',
  );
  static const parseAppId = String.fromEnvironment('PARSE_APP_ID');
  static const parseClientKey = String.fromEnvironment('PARSE_CLIENT_KEY');
  static bool get parseConfigured => parseAppId.isNotEmpty;

  // ---------- Firebase (hanya untuk FCM; tanpa google-services.json) ----------
  static const firebaseApiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const firebaseAppId = String.fromEnvironment('FIREBASE_APP_ID');
  static const firebaseSenderId = String.fromEnvironment('FIREBASE_SENDER_ID');
  static const firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
  );
  static bool get firebaseConfigured =>
      firebaseApiKey.isNotEmpty && firebaseAppId.isNotEmpty;

  static bool get isProd => flavor == AppFlavor.prod;

  static const bool isDebug = kDebugMode;
}
