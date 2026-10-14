# Rilis: signing, versi, changelog

## Signing Android

1. `just keygen` membuat `android/keystore/release.jks` (jawab pertanyaan keytool).
2. Salin `android/key.properties.example` ke `android/key.properties`, isi
   password dan alias. Keduanya di-gitignore; simpan keystore dan password di
   tempat aman (password manager, secret CI).
3. `just env=prod build-release` atau `just env=prod build-aab`.

Tanpa `key.properties`, build release memakai debug key supaya
`flutter run --release` tetap bisa dipakai saat pengembangan. Build release
juga mengaktifkan minify dan shrink resources; tambahkan aturan di
`android/app/proguard-rules.pro` bila ada crash.

iOS: signing diatur di Xcode (Signing & Capabilities) dengan tim Apple
Developer; tidak ada file rahasia yang disimpan di repo.

## Versi

`version: x.y.z+n` di `pubspec.yaml`. `just bump patch|minor|major|x.y.z`
menaikkan versi dan selalu menaikkan build number `n`.

## Changelog

`CHANGELOG.md` mengikuti Keep a Changelog. Tulis setiap perubahan di bagian
`[Unreleased]` dengan sub-bagian Added / Changed / Fixed / Removed.

## Alur rilis

```bash
just check
just release 1.2.0        # changelog → [1.2.0] - tanggal, bump pubspec, commit, tag v1.2.0
git push && git push --tags
just env=prod build-aab   # unggah ke Play Console
```

## Peringatan build yang diketahui

- `WARNING: Your app uses the following plugins that apply Kotlin Gradle Plugin (KGP): firebase_core`
  berasal dari plugin `firebase_core` (versi 4.15.0 masih memakai
  `apply plugin: 'kotlin-android'`), bukan dari project ini. Build tetap
  berhasil. Dependabot akan membawa versi baru; saat FlutterFire merilis versi
  dengan Built-in Kotlin, peringatan hilang sendiri. Pantau di
  https://github.com/firebase/flutterfire.
- `Warning: SDK processing. This version only understands SDK XML versions up to 3`
  muncul bila ada dua salinan `cmdline-tools` di `~/.androidsdk` (hasil unzip
  manual di `latest` dan `cmdline-tools;latest` dari sdkmanager di `latest-2`).
  Sisakan satu salinan di `cmdline-tools/latest`.
