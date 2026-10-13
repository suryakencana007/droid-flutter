# Branding: ikon launcher dan splash native

Sumber gambar ada di `assets/brand/`:

| File                 | Dipakai untuk                                             |
|----------------------|-----------------------------------------------------------|
| `icon.png`           | Ikon launcher 1024×1024 (Android legacy, iOS)              |
| `icon_foreground.png`| Lapisan depan ikon adaptif Android dan ikon splash Android 12+; gambar di tengah, sisakan margin ~17% tiap sisi |
| `splash.png`         | Gambar splash Android < 12 dan iOS                         |

Warna latar ikon adaptif dan splash diatur di `flutter_launcher_icons.yaml`
dan `flutter_native_splash.yaml` (`#18181b` gelap, `#fafafa` terang).

## Mengganti

1. Timpa ketiga PNG di `assets/brand/` (ukuran sama).
2. Sesuaikan warna di kedua YAML bila perlu.
3. `just brand` (= `just icons` + `just splash`).
4. Commit file hasil generate di `android/app/src/main/res/` dan `ios/Runner/`.

Gambar bawaan dibuat dengan ImageMagick sebagai placeholder; ganti sebelum
rilis.

## Git hook

`just setup` memasang `core.hooksPath .githooks`; `.githooks/pre-commit`
menjalankan `just check` sebelum setiap commit. Lewati sekali dengan
`git commit --no-verify`.

## Integration test

`integration_test/app_test.dart` menjalankan alur sign in → home → profil →
keluar di device nyata dengan storage in-memory dan `FakeAuthApi`. Jalankan
dengan `just itest` (Waydroid harus aktif). Tambahkan skenario lain di folder
yang sama.
