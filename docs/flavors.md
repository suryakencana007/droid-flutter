# Flavor: dev, staging, prod

Konfigurasi per lingkungan disimpan sebagai JSON di `env/` dan dimasukkan ke
build lewat `--dart-define-from-file`. Tidak ada product flavor Gradle atau
scheme Xcode, jadi satu build setup untuk semua lingkungan.

| Kunci          | Dibaca oleh         | Contoh dev               |
|----------------|---------------------|--------------------------|
| `APP_ENV`      | `Env.flavor`        | `dev`                    |
| `API_BASE_URL` | `Env.apiBaseUrl`    | `http://10.0.2.2:8080`   |
| `USE_FAKE_API` | `Env.useFakeApi`    | `true`                   |
| `LOG_LEVEL`    | `Env.logLevel`      | `ALL`                    |

Semua recipe `just` yang membangun app menerima `env=`:

```bash
just run                  # dev
just env=staging run
just env=prod build-release
```

`flutter run` tanpa define memakai nilai default yang setara `env/dev.json`.
Jangan menaruh rahasia (API key privat) di file ini karena ikut ter-embed di
binary; rahasia server tetap di server.

Saat bukan prod, pojok kanan atas app menampilkan pita nama flavor.

## Menambah lingkungan

1. Salin `env/staging.json` ke `env/<nama>.json`.
2. Tambahkan nilai ke enum `AppFlavor` di `lib/shared/config/env.dart`.
3. Jalankan `just env=<nama> run`.

## Error handling dan logging

- `lib/app/bootstrap.dart` memasang `FlutterError.onError`,
  `PlatformDispatcher.onError`, dan `ErrorWidget.builder` (layar ramah di
  build non-debug), lalu menjalankan app dengan `AppProviderObserver` yang
  melaporkan provider gagal.
- Logger: `final _log = log('nama_area');` lalu `_log.info(...)`. Level
  diatur `LOG_LEVEL`.
- `CrashReporter` (`lib/shared/lib/errors/crash_reporter.dart`) default
  hanya mencatat. Untuk Sentry/Crashlytics, buat implementasi lalu di
  `main.dart` panggil `bootstrap(container: ProviderContainer(overrides:
  [crashReporterProvider.overrideWithValue(...)], observers:
  [AppProviderObserver()]))`. User aktif otomatis diteruskan lewat `setUser`.
