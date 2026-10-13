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

## Memakai Parse Server + FCM (bawaan template)

`ParseFcmPushService` aktif otomatis bila `PARSE_APP_ID` dan `FIREBASE_API_KEY`
+ `FIREBASE_APP_ID` terisi di `env/<flavor>.json`:

| Kunci                 | Sumber                                                        |
|-----------------------|---------------------------------------------------------------|
| `PARSE_SERVER_URL`    | URL server, contoh `https://parse.kubus.work/parse` (termasuk mount path)                 |
| `PARSE_APP_ID`        | `appId` di konfigurasi Parse Server                           |
| `PARSE_CLIENT_KEY`    | `clientKey` (boleh kosong bila server tidak memakainya)       |
| `FIREBASE_API_KEY`    | Firebase console → Project settings → app Android → `apiKey`  |
| `FIREBASE_APP_ID`     | `mobilesdk_app_id` / `appId` (format `1:...:android:...`)     |
| `FIREBASE_SENDER_ID`  | `project_number` / `messagingSenderId`                        |
| `FIREBASE_PROJECT_ID` | `project_id`                                                  |

Firebase diinisialisasi dari nilai itu (tanpa `google-services.json`), jadi
build tetap jalan di flavor yang belum dikonfigurasi. Package name Android
harus sama dengan yang didaftarkan di Firebase (`com.kubus.work.droid`).

Alur: token FCM → `_Installation` di Parse (`deviceToken`, `pushType: gcm`,
`GCMSenderId`, `userId` setelah sign in) → server mengirim lewat adapter
push Parse yang dikonfigurasi dengan service account FCM:

```js
// parse-server config
push: { android: { firebaseServiceAccount: '/path/service-account.json' } }
```

Kirim uji dengan master key (dari mesin pengembang, bukan dari app):

```bash
curl -X POST https://parse.kubus.work/parse/push \
  -H "X-Parse-Application-Id: $PARSE_APP_ID" \
  -H "X-Parse-Master-Key: $PARSE_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{"where":{"deviceType":"android"},"data":{"title":"Halo","alert":"Dari Parse","route":"/notes"}}'
```

`route` di `data` dibuka saat notifikasi diketuk. Push tertarget per user:
`"where":{"userId":"<id user>"}`.

Catatan: FCM di Android butuh Google Play Services di perangkat; iOS butuh
APNs key di Firebase dan `GoogleService-Info.plist`/opsi iOS sendiri.
