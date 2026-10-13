# Alur layar bawaan

Template ini sudah berisi layar yang hampir selalu ada di aplikasi: splash,
onboarding, sign in / sign up / lupa password, menu utama dengan bottom tabs,
profil, pengaturan, dan sign out. Semuanya disusun mengikuti FSD dan memakai
komponen forui lewat `shared/ui`.

## Alur

```
splash ──(sesi & flag onboarding dipulihkan)──► onboarding (sekali)
   │                                               │
   │ token valid                                   ▼
   ▼                                           sign in ◄──► sign up
 home ◄───────────────────────────────────────── │  ▲
   │                                               ▼  │
   │ bottom tabs: Beranda / Jelajah / Profil   lupa password
   ▼
 profil ──► pengaturan (tema, versi) ──► keluar ──► sign in
```

Aturan perpindahan ada di satu tempat: `_redirect` di
`lib/app/router/app_router.dart`. Router mengevaluasi ulang aturan setiap
`currentUserProvider` atau `onboardingDoneProvider` berubah (lewat
`RouterRefresh`).

| Kondisi                                   | Tujuan        |
|-------------------------------------------|---------------|
| sesi / flag onboarding masih dimuat       | `/splash`     |
| onboarding belum selesai                  | `/onboarding` |
| belum sign in, bukan di halaman auth      | `/sign-in`    |
| sudah sign in, di splash/onboarding/auth  | `/`           |

## Route → slice

| Route              | Page slice              | Feature / widget yang dipakai                     |
|--------------------|-------------------------|---------------------------------------------------|
| `/splash`          | `pages/splash`          | `AppLogo`, `FCircularProgress`                    |
| `/onboarding`      | `pages/onboarding`      | `features/complete_onboarding`                    |
| `/sign-in`         | `pages/sign_in`         | `features/sign_in`, `widgets/auth_layout`         |
| `/sign-up`         | `pages/sign_up`         | `features/sign_up`, `widgets/auth_layout`         |
| `/forgot-password` | `pages/forgot_password` | `features/forgot_password`, `widgets/auth_layout` |
| `/`                | `pages/home`            | `entities/user` (`UserCard`), `widgets/app_bar`   |
| `/notes`           | `pages/notes`           | `entities/note` (`NoteTile`), `AsyncValueView`, pull-to-refresh, infinite scroll |
| `/notes/new`       | `pages/note_edit`       | `features/create_note`                            |
| `/notes/:id`       | `pages/note_detail`     | `features/delete_note`                            |
| `/notes/:id/edit`  | `pages/note_edit`       | `features/edit_note`                              |
| `/profile`         | `pages/profile`         | `features/sign_out`, `entities/user`              |
| `/profile/settings`| `pages/settings`        | `features/toggle_theme` (`ThemeModeSelector`), `features/sign_out` |

Tiga tab utama dibungkus `widgets/app_shell` (`FBottomNavigationBar` di atas
`StatefulShellRoute.indexedStack`), jadi state tiap tab terjaga.

## Contoh CRUD: catatan

Tab Catatan adalah pola list → detail → form yang bisa disalin untuk entity
lain:

- `entities/note/api`: kontrak `NoteApi`, `FakeNoteApi` (40 contoh, in-memory)
  dan `DioNoteApi` (`/notes` REST); dipilih lewat `USE_FAKE_API`.
- `entities/note/model/notes_provider.dart`: `NotesNotifier` memegang
  `Paginated<Note>` dengan `loadMore()`, `refresh()`, `upsert()`, `remove()`
  sehingga daftar tetap sinkron setelah buat/ubah/hapus tanpa memuat ulang.
  `noteProvider(id)` mengambil dari daftar bila ada, selain itu dari API.
- `entities/note/ui/note_form.dart`: form judul + isi dengan callback
  `onSubmit`; dipakai `features/create_note` dan `features/edit_note`.
- `features/delete_note`: tombol hapus dengan konfirmasi dan toast.
- `pages/notes`: `AsyncValueView` + `RefreshIndicator` + `ScrollController`
  untuk memuat halaman berikutnya saat mendekati bawah.

Untuk entity baru: `just slice entity produk ui model api`, salin pola di atas,
lalu daftarkan route dan tab.

## State dan penyimpanan

| Data              | Provider                     | Disimpan di                         |
|-------------------|------------------------------|-------------------------------------|
| user aktif        | `currentUserProvider`        | token di `SecureStore` (`TokenStore`) |
| flag onboarding   | `onboardingDoneProvider`     | `KeyValueStore` key `onboarding_done` |
| mode tema         | `themeModeProvider`          | `KeyValueStore` key `theme_mode`    |

`KeyValueStore` memakai `shared_preferences`, `SecureStore` memakai
`flutter_secure_storage`. Keduanya punya implementasi memory
(`MemoryKeyValueStore`, `MemorySecureStore`) untuk test, dioverride lewat
`keyValueStoreProvider` dan `secureStoreProvider`.

## Model dan codegen

Model data memakai [freezed](https://pub.dev/packages/freezed) +
json_serializable, contoh `lib/entities/user/model/user.dart`:

```dart
@freezed
abstract class User with _$User {
  const User._();                      // agar bisa punya getter/method
  const factory User({required String id, required String name}) = _User;
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

Setelah mengubah model jalankan `just gen` (atau `just gen-watch` saat
mengembangkan). File `*.freezed.dart` dan `*.g.dart` ikut di-commit supaya
clone langsung bisa `just check`; analyzer dan test arsitektur mengabaikannya.

## Mengganti backend auth

Kontrak ada di `lib/entities/user/api/auth_api.dart`:

```dart
abstract interface class AuthApi {
  Future<AuthResult> signIn({required String email, required String password});
  Future<AuthResult> signUp({required String name, required String email, required String password});
  Future<User?> me(String token);
  Future<void> signOut(String token);
  Future<void> requestPasswordReset(String email);
}
```

Default-nya `FakeAuthApi` (in-memory, akun demo `demo@example.com` /
`password123`). Untuk backend sungguhan:

1. Buat `lib/entities/user/api/dio_auth_api.dart` yang memakai `dioProvider`
   dari `shared/api` (header `Authorization` sudah dipasang `AuthInterceptor`).
2. Ganti `authApiProvider` di `auth_api_provider.dart`, atau override di
   `main.dart`: `authApiProvider.overrideWith((ref) => DioAuthApi(ref.watch(dioProvider)))`.
3. Lempar `AuthException(code, message)` untuk error yang boleh ditampilkan;
   `describeAuthError` menyembunyikan error lain di balik pesan umum.

Feature `sign_in`, `sign_up`, `sign_out`, `forgot_password` tidak perlu diubah.

## Menambah tab

1. `just slice page laporan`, isi `ui/laporan_page.dart`.
2. Tambah path di `AppRoutes` dan `StatefulShellBranch` baru di `app_router.dart`.
3. Tambah `FBottomNavigationBarItem` di `widgets/app_shell`.

## Menambah halaman biasa

1. `just slice page detail_produk`.
2. Tambah path di `AppRoutes`, lalu `GoRoute` di branch yang sesuai (route
   bersarang di bawah tab agar bottom bar tetap tampil) atau di level atas.
3. Navigasi dengan `context.go(AppRoutes.detailProduk)`.

## Memulai app baru dari template

```bash
# Use this template di GitHub, lalu:
git clone <repo-baru> && cd <repo-baru>
just rename kasir_app com.perusahaan "Kasir App"
just setup
just check
```

`tool/rename.dart` mengganti nama package, semua import, application id
Android, bundle id iOS, label launcher, dan `AppInfo.name`. Tool ini membaca
identitas saat ini dari file sumber, jadi aman dijalankan berulang.
