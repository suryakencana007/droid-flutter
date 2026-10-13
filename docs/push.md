# Push notifications

`PushService` (`lib/shared/lib/push/push_service.dart`) menyembunyikan sumber
notifikasi di balik satu kontrak: `initialize(onOpened)`, `token()`,
`onMessage`, `showLocal()`. Bawaan template:

- `LocalPushService`: notifikasi lokal lewat `flutter_local_notifications`
  (channel `default`). `token()` mengembalikan `null`.
- `NoopPushService`: untuk test atau flavor tanpa notifikasi.
- `MemoryPushService`: merekam notifikasi dan mensimulasikan ketukan di test.

`lib/app/push_bootstrap.dart` menginisialisasi service saat app mulai,
mengarahkan `message.route` ke go_router saat notifikasi diketuk (termasuk
saat app dibuka dari keadaan tertutup), dan menampilkan pesan foreground
sebagai notifikasi lokal.

Pengaturan punya toggle "Terima notifikasi" (meminta izin sistem lewat
`ensurePermission`) dan tombol "Kirim notifikasi uji" yang membuka `/notes`
saat diketuk.

## Menukar ke Firebase Cloud Messaging

1. `flutter pub add firebase_core firebase_messaging`, tambahkan
   `google-services.json` dan `GoogleService-Info.plist` (jangan commit bila
   repo publik), dan plugin Gradle Google Services.
2. Buat `FirebasePushService implements PushService`:
   - `initialize`: `Firebase.initializeApp()`, `FirebaseMessaging.instance
     .getInitialMessage()` → `onOpened`, `FirebaseMessaging.onMessageOpenedApp`
     → `onOpened`, dan tetap inisialisasi `LocalPushService` untuk menampilkan
     pesan foreground.
   - `token`: `FirebaseMessaging.instance.getToken()`; kirim ke server setelah
     sign in (misalnya di `SignInController`).
   - `onMessage`: `FirebaseMessaging.onMessage.map(_toPushMessage)`; ambil
     `route` dari `message.data['route']`.
   - Background handler: fungsi top-level `@pragma('vm:entry-point')` yang
     didaftarkan dengan `FirebaseMessaging.onBackgroundMessage`.
3. Override di `main.dart`:
   `pushServiceProvider.overrideWithValue(FirebasePushService(...))`.

Feature, page, dan test tidak berubah.
