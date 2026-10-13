# Feature flags (Flagsmith)

`FeatureFlags` (`lib/shared/lib/flags/feature_flags.dart`) punya dua sumber:

- `LocalFeatureFlags`: dari `FEATURE_FLAGS` di `env/<flavor>.json`, format
  `nama:true;nama2:false;nama3:nilai`. Dipakai bila `FLAGSMITH_ENV_KEY` kosong.
- `FlagsmithFeatureFlags`: dari Flagsmith (paket `flagsmith`) dengan
  environment key `FLAGSMITH_ENV_KEY`. Nilai terakhir yang berhasil dimuat
  dipakai saat jaringan gagal. Identitas user diteruskan saat sign in sehingga
  segmentasi per user bekerja.

## Membaca flag

```dart
final canCreate = ref.watch(flagProvider('notes_create_enabled'));
if (canCreate) ... // flag yang belum ada / belum dimuat dianggap nonaktif
```

Snapshot lengkap: `ref.watch(flagsProvider)` (`Map<String, FlagValue>`),
muat ulang dengan `ref.read(flagsProvider.notifier).refresh()`.

Contoh yang sudah ada: `notes_create_enabled` menyembunyikan tombol buat
catatan, `beta_badge` menampilkan badge Beta di beranda.

## Memakai Flagsmith

1. Buat project dan environment di Flagsmith, salin *client-side environment
   key*.
2. Isi `FLAGSMITH_ENV_KEY` di `env/staging.json` / `env/prod.json`.
3. Buat flag `notes_create_enabled` dan `beta_badge` di dashboard.

Halaman "Feature flags" di pengaturan (flavor non-prod) menampilkan nilai
aktif beserta sumbernya; berguna saat mencocokkan dashboard dan app.
