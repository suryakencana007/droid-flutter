# droid

Flutter app dengan arsitektur Feature-Sliced Design (FSD). Aturan layer, segment,
dan import ada di `README.md` dan ditegakkan oleh `test/architecture/fsd_layers_test.dart`.
Buat slice baru dengan `dart run tool/fsd.dart <layer> <slice>`.

## Git, PR, dan repo

- **Tanpa jejak AI/Claude.** Jangan tambahkan trailer `Co-Authored-By: Claude`,
  baris `Generated with Claude Code`, link sesi Claude, atau sebutan asisten AI
  apa pun di commit message, judul/deskripsi PR, komentar review, deskripsi repo,
  maupun file di repo. `.claude/settings.json` sudah mematikan attribution otomatis;
  jangan tulis manual juga.
- Commit message: baris pertama imperatif dan ringkas, body menjelaskan "apa" dan
  "mengapa" dalam bentuk bullet seperlunya.
- Jalankan `flutter analyze` dan `flutter test` sebelum commit.

## Dokumentasi project

Pengetahuan project disimpan di repo, bukan di memori asisten, agar tetap ada
saat ganti sesi atau akun. Letakkan catatan operasional di `docs/`:

- `docs/waydroid.md`: menjalankan dan mengendalikan aplikasi di Waydroid.
- `docs/ui-kit.md`: UI kit forui, wajib diimpor lewat `shared/ui/index.dart`.
- `docs/screens.md`: alur splash/onboarding/auth/tabs, aturan redirect router,
  contoh CRUD catatan, cara mengganti `AuthApi`, menambah tab/halaman, dan
  `tool/rename.dart`.
- `docs/flavors.md`: env/*.json, `Env`, logging, `CrashReporter`.
- `docs/i18n.md`: ARB, `context.l10n`, menambah string/bahasa.
- `docs/networking.md`: `ApiException`, 401, `DioAuthApi`, `AsyncValueView`, offline.
- `docs/branding.md`: ikon/splash (`just brand`), git hook, integration test.
  Material diimpor dari `package:material_ui`, bukan `package:flutter/material.dart`.

## Task runner

Gunakan `just` (lihat `justfile`) daripada mengetik perintah flutter/adb panjang:
`just check` sebelum commit, `just run` untuk Waydroid, `just slice <layer> <nama>`
untuk slice FSD baru. Tambahkan recipe baru ke `justfile` saat ada alur berulang.

## Toolchain

- Flutter dan JDK dipin di `mise.toml`; `ANDROID_HOME` menunjuk ke `~/.androidsdk`.
- Target platform hanya Android dan iOS. Application ID: `com.kubus.work.droid`.
