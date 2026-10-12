# droid

Bootstrap aplikasi Flutter dengan arsitektur **Feature-Sliced Design (FSD)**.

Target platform: **Android** dan **iOS**. Application ID / bundle ID: `com.kubus.work.droid`.

## Prasyarat

Toolchain dikelola lewat [mise](https://mise.jdx.dev): Flutter dan JDK dipin di
`mise.toml`, `ANDROID_HOME` diekspor otomatis ke `~/.androidsdk`.

```bash
mise install          # memasang Flutter + Temurin JDK 21 sesuai mise.toml
flutter doctor        # cek toolchain
```

Pemasangan Android SDK di mesin baru (sekali saja), cukup `sdkmanager` dari
`commandlinetools` yang diletakkan di `~/.androidsdk/cmdline-tools/latest`:

```bash
sdkmanager --licenses
sdkmanager "platform-tools" "platforms;android-36" "build-tools;36.0.0" "ndk;28.2.13676358"
flutter config --android-sdk ~/.androidsdk
```

## Menjalankan

```bash
flutter pub get
flutter run           # pilih device/emulator yang tersedia
flutter test          # unit + widget test + uji aturan arsitektur
flutter analyze
flutter build apk --debug
```

Konfigurasi runtime lewat `--dart-define`, misalnya:

```bash
flutter run --dart-define=API_BASE_URL=https://api.example.com
```

## Struktur `lib/`

```
lib/
├── main.dart            # entry point, hanya memanggil layer app
├── app/                 # inisialisasi app: router, theme, provider global
├── pages/               # satu slice per halaman/route
├── widgets/             # blok UI komposit yang merakit features + entities
├── features/            # interaksi user yang bernilai bisnis (aksi)
├── entities/            # entitas bisnis: model + tampilan dasarnya
└── shared/              # kode reusable tanpa makna bisnis: api, config, lib, ui
```

Setiap **slice** (folder di `pages/`, `widgets/`, `features/`, `entities/`)
dibagi ke dalam **segment**:

| Segment  | Isi                                                     |
|----------|---------------------------------------------------------|
| `ui/`    | Widget                                                  |
| `model/` | State, provider, tipe data, logika domain               |
| `api/`   | Akses data: HTTP, database, storage                     |
| `lib/`   | Helper internal slice                                   |
| `config/`| Konstanta / konfigurasi slice                           |

Setiap slice wajib punya `index.dart` sebagai **public API**. Kode lain hanya
boleh mengimpor slice lewat file itu.

## Aturan import

1. **Searah ke bawah.** Sebuah layer hanya boleh mengimpor layer di bawahnya:
   `app → pages → widgets → features → entities → shared`.
2. **Tidak ada import antar slice sejajar.** `features/a` tidak boleh mengimpor
   `features/b`. Kalau butuh, turunkan kode bersama ke layer di bawahnya atau
   rakit keduanya di layer di atasnya.
3. **Lintas slice lewat public API.** Gunakan
   `package:droid/<layer>/<slice>/index.dart`, bukan path ke file internal.
4. **Di dalam slice pakai import relatif.** Contoh: `import '../model/foo.dart';`
5. `app/` dan `shared/` tidak memiliki slice, hanya segment, sehingga bebas
   saling impor di dalam layernya sendiri.

Aturan ini diuji otomatis oleh `test/architecture/fsd_layers_test.dart`.
Pelanggaran membuat `flutter test` gagal dengan pesan yang menunjuk file dan
import yang bermasalah.

## Membuat slice baru

```bash
dart run tool/fsd.dart feature auth            # lib/features/auth/{ui,model}
dart run tool/fsd.dart entity product ui model api
dart run tool/fsd.dart page profile
dart run tool/fsd.dart widget sidebar
```

Setelah membuat page baru, daftarkan route-nya di `lib/app/router/app_router.dart`
dan path-nya di `lib/shared/config/app_routes.dart`.

## Dependensi utama

- `flutter_riverpod`: dependency injection dan state management
- `go_router`: routing deklaratif
- `dio`: HTTP client (`dioProvider` di `shared/api`)

## Contoh alur yang sudah ada

`HomePage` (pages) memakai `DroidAppBar` (widgets) yang menyertakan
`ToggleThemeButton` (features). Halaman yang sama menampilkan `UserCard`
(entities) dengan spasi dari `shared/ui`. Layer `app` membaca
`themeModeProvider` dari feature `toggle_theme` untuk mengatur `themeMode`.
