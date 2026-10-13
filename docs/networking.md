# Jaringan dan state async

## Dio client (`shared/api`)

`dioProvider` memasang tiga interceptor berurutan:

1. `AuthInterceptor`: header `Authorization: Bearer <token>` dari `TokenStore`
   bila request belum membawanya.
2. `UnauthorizedInterceptor`: respons 401 di luar `/auth/sign-in` dan
   `/auth/sign-up` menaikkan `sessionExpiredProvider`. `currentUserProvider`
   mendengarkan provider itu, menghapus token, dan mengosongkan user, sehingga
   router otomatis kembali ke sign in.
3. `ErrorInterceptor`: setiap `DioException` membawa `ApiException` di
   `error`, jadi pemanggil cukup `ApiException.fromDio(e)`.

`ApiException.kind` (`network`, `timeout`, `unauthorized`, `forbidden`,
`notFound`, `server`, `cancelled`, `unknown`) punya pesan terlokalisasi lewat
`describe(l10n)`; `describeError(error, l10n)` di `shared/lib/errors`
memakainya untuk error apa pun yang mengimplementasikan `DescribableError`.

## Mengganti backend auth

`authApiProvider` memilih `FakeAuthApi` bila `USE_FAKE_API=true`
(`env/dev.json`), selain itu `DioAuthApi`. Kontrak REST `DioAuthApi` ada di
dokumentasi kelasnya (`lib/entities/user/api/dio_auth_api.dart`): path
`/auth/*`, respons `{token, user}`. Ubah path atau parsing di satu file itu;
feature dan page tidak tersentuh. Unit test memakai `HttpClientAdapter` palsu,
lihat `test/entities/dio_auth_api_test.dart`.

## Widget state async (`shared/ui`)

```dart
AsyncValueView(
  value: ref.watch(itemsProvider),
  onRetry: () => ref.invalidate(itemsProvider),
  isEmpty: (items) => items.isEmpty,
  data: (items) => ListView(...),
)
```

Loading → `LoadingView`, error → `ErrorView` dengan tombol coba lagi dan pesan
dari `describeError`, kosong → `EmptyView`. `ErrorView` dan `EmptyView` juga
bisa dipakai langsung.

## Offline

`isOnlineProvider` (`shared/lib/connectivity`) membungkus `connectivity_plus`.
`AppShell` menampilkan `OfflineBanner` saat `false`. Di test, override dengan
`isOnlineProvider.overrideWith((ref) => Stream.value(true))`.
