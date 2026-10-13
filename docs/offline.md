# Cache offline (drift)

Catatan dibaca dan ditulis lewat `CachedNoteApi`
(`lib/entities/note/api/cached_note_api.dart`) yang membungkus API jaringan
dengan database drift (`lib/shared/lib/db/app_database.dart`).

| Situasi                       | Perilaku                                                        |
|-------------------------------|-----------------------------------------------------------------|
| Online                        | Jaringan dipanggil, hasil disimpan ke tabel `note_rows`.        |
| Offline / jaringan gagal      | Daftar dan detail dibaca dari cache.                            |
| Buat / ubah / hapus offline   | Diterapkan ke cache dan dicatat di `pending_ops`; id sementara `local-*`. |
| Koneksi kembali               | `noteSyncProvider` menjalankan antrian berurutan lalu memuat ulang daftar. Id lokal diganti id server. |

Halaman catatan menampilkan jumlah perubahan yang menunggu beserta tombol
"Sinkronkan"; pull-to-refresh juga menyinkronkan dulu.

Status online datang dari `isOnlineProvider` (`connectivity_plus`); request yang
gagal dengan `ApiErrorKind.network`/`timeout` juga diperlakukan sebagai offline.

## Menambah entity lain

1. Tambahkan tabel di `app_database.dart`, naikkan `schemaVersion`, tulis
   migrasi di `migration`, lalu `just gen`.
2. Buat `Cached<Entity>Api` mengikuti pola `CachedNoteApi`: baca dari jaringan
   → simpan cache; tulis offline → cache + `pending_ops` dengan `entity` berbeda.
3. Test dengan `AppDatabase.memory()` seperti
   `test/entities/cached_note_api_test.dart`.

Konflik diselesaikan sederhana: operasi lokal menang saat dikirim; server
yang menolak (bukan error jaringan) membuat operasi itu dibuang dari antrian.
