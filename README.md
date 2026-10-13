# droid

[![CI](https://github.com/suryakencana007/droid-flutter/actions/workflows/ci.yml/badge.svg)](https://github.com/suryakencana007/droid-flutter/actions/workflows/ci.yml)

Template aplikasi Flutter yang siap dipakai sebagai bootstrap: arsitektur
**Feature-Sliced Design (FSD)**, UI kit **forui** (bergaya shadcn/ui), dan
alur layar yang hampir selalu ada di sebuah app. Repo ini adalah GitHub
template; lihat [Memulai app baru](#memulai-app-baru-dari-template).

Target platform: **Android** dan **iOS**. Application ID / bundle ID:
`com.kubus.work.droid`.

## Yang sudah ada

| Area            | Isi                                                                 | Dokumen |
|-----------------|---------------------------------------------------------------------|---------|
| Arsitektur      | Layer `app > pages > widgets > features > entities > shared`, aturan import diuji otomatis, generator slice | [docs/ui-kit.md](docs/ui-kit.md), bagian [Aturan import](#aturan-import) |
| UI kit          | forui lewat satu pintu `shared/ui`, tema terang/gelap persisten, `AsyncValueView`/`ErrorView`/`EmptyView`, dialog konfirmasi | [docs/ui-kit.md](docs/ui-kit.md) |
| Alur layar      | Splash, onboarding, sign in / sign up / lupa password, bottom tabs (sidebar di tablet), profil, pengaturan, keluar | [docs/screens.md](docs/screens.md) |
| Contoh CRUD     | Catatan: daftar berhalaman, detail, buat/ubah/hapus                  | [docs/screens.md](docs/screens.md) |
| Auth & data     | `AuthApi` dengan `FakeAuthApi` dan `DioAuthApi`, token di secure storage, 401 otomatis keluar, pemetaan error jaringan, banner offline | [docs/networking.md](docs/networking.md) |
| Flavor          | dev / staging / prod lewat `env/*.json`, pita flavor, logger, `CrashReporter` | [docs/flavors.md](docs/flavors.md) |
| i18n            | Indonesia + English (ARB), pemilih bahasa                            | [docs/i18n.md](docs/i18n.md) |
| Model           | freezed + json_serializable, `just gen`                              | [docs/screens.md](docs/screens.md) |
| Branding        | Ikon launcher adaptif dan splash native dari `assets/brand`          | [docs/branding.md](docs/branding.md) |
| Kualitas        | Analyzer ketat, widget test alur end-to-end, integration test di device, hook pre-commit, CI GitHub Actions, Dependabot | [docs/branding.md](docs/branding.md) |
| Device          | Alur kerja Waydroid (Android container di Linux)                     | [docs/waydroid.md](docs/waydroid.md) |

## Prasyarat

Toolchain dikelola lewat [mise](https://mise.jdx.dev): Flutter, JDK, dan just
dipin di `mise.toml`; `ANDROID_HOME` diekspor otomatis ke `~/.androidsdk`.

```bash
mise install          # Flutter + Temurin JDK 21 + just
just setup            # pub get, codegen, git hook
flutter doctor
```

Pemasangan Android SDK di mesin baru (sekali saja), cukup `sdkmanager` dari
`commandlinetools` yang diletakkan di `~/.androidsdk/cmdline-tools/latest`:

```bash
sdkmanager --licenses
sdkmanager "platform-tools" "platforms;android-36" "build-tools;36.0.0" "ndk;28.2.13676358"
flutter config --android-sdk ~/.androidsdk
```

## Perintah harian

Semua dibungkus [just](https://github.com/casey/just); `just` tanpa argumen
menampilkan daftar lengkap. Flavor dipilih dengan `env=` (default `dev`).

| Perintah                     | Fungsi                                              |
|------------------------------|-----------------------------------------------------|
| `just check`                 | `flutter analyze` + `flutter test`                  |
| `just run` / `just env=staging run` | Jalankan di Waydroid dengan flavor            |
| `just build-apk`, `just build-release` | Build APK                                 |
| `just install`, `just launch`, `just stop` | Pasang/buka/hentikan di Waydroid      |
| `just screenshot`, `just tap X Y`, `just type "..."`, `just logcat` | Kendali device |
| `just itest`                 | Integration test di device                          |
| `just gen`, `just gen-watch` | Codegen freezed/json                                |
| `just l10n`                  | Generate lokalisasi dari ARB                        |
| `just brand`                 | Ikon launcher + splash native                       |
| `just slice feature auth`    | Buat slice FSD baru                                 |
| `just rename nama com.org "Judul"` | Ganti identitas app dari template              |

Tanpa just: `flutter run --dart-define-from-file=env/dev.json`, `flutter test`,
`flutter analyze`.

## Akun demo

Flavor dev memakai `FakeAuthApi` in-memory: `demo@example.com` /
`password123`. Data catatan contoh juga in-memory.

## Struktur `lib/`

```
lib/
├── main.dart            # memanggil app/bootstrap.dart
├── app/                 # bootstrap, router (+ redirect), theme, App widget
├── pages/               # satu slice per route
├── widgets/             # blok UI komposit (AppShell, AuthLayout, AppBar)
├── features/            # aksi user (sign_in, create_note, toggle_theme, ...)
├── entities/            # entitas bisnis (user, note): model, api, ui dasar
└── shared/              # api, config, l10n, lib (storage, errors, logging), ui
```

Setiap **slice** (folder di `pages/`, `widgets/`, `features/`, `entities/`)
dibagi ke dalam **segment** `ui/`, `model/`, `api/`, `lib/`, `config/` dan
wajib punya `index.dart` sebagai public API.

## Aturan import

1. **Searah ke bawah.** `app → pages → widgets → features → entities → shared`.
2. **Tidak ada import antar slice sejajar.** Turunkan kode bersama ke layer di
   bawahnya atau rakit di layer di atasnya.
3. **Lintas slice lewat public API** `package:droid/<layer>/<slice>/index.dart`.
4. **Di dalam slice pakai import relatif.**
5. **forui hanya lewat `shared/ui/index.dart`**, dan Material dari
   `package:material_ui`, bukan `package:flutter/material.dart`.

Semua aturan diuji oleh `test/architecture/fsd_layers_test.dart`; pelanggaran
membuat `just check` gagal dengan pesan yang menunjuk file dan importnya.

## Membuat slice baru

```bash
just slice feature auth                        # lib/features/auth/{ui,model}
just slice entity product ui model api
just slice page profile
```

## Memulai app baru dari template

```bash
# "Use this template" di GitHub, lalu:
git clone <repo-baru> && cd <repo-baru>
just rename kasir_app com.perusahaan "Kasir App"   # package, app id, judul
just setup
# ganti assets/brand/*.png, lalu:
just brand
just check
```

Setelah itu ganti backend: isi `env/*.json`, lalu sesuaikan `DioAuthApi` dan
`DioNoteApi` dengan kontrak server (lihat [docs/networking.md](docs/networking.md)).

## Dependensi utama

- `flutter_riverpod`: DI dan state; `go_router`: routing; `dio`: HTTP
- `forui` + `forui_lucide`: UI kit dan ikon; `material_ui`: Material 3
- `shared_preferences`, `flutter_secure_storage`: preferensi dan token
- `freezed`, `json_serializable`: model; `intl` + `flutter_localizations`: i18n
- `connectivity_plus`, `package_info_plus`, `logging`
