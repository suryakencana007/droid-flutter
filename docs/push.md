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
saat diketuk. Toggle itu nyata di tiga lapis lewat `PushService.setEnabled`:

- **off**: token FCM dihapus (`deleteToken`) dan `deviceToken` di
  `_Installation` Parse di-null-kan, jadi server tidak lagi menargetkan
  perangkat (`_PushStatus.numSent` 0); pesan foreground dan handler background
  juga mengabaikan pesan yang masih sempat masuk.
- **on**: token diminta lagi dan didaftarkan bersama `userId`.
- Default **off** (opt-in): tidak ada `_Installation` sampai user mengaktifkan.
- Hubungan dengan izin sistem: izin `POST_NOTIFICATIONS` adalah prasyarat,
  toggle adalah preferensi app. Status izin (`permissionStatusProvider` di
  `shared/lib/permissions`) dimuat ulang setiap app kembali ke depan dan
  setelah dialog izin, sehingga tile "Izin → Notifikasi" selalu mutakhir. Jika
  izin dicabut dari pengaturan sistem (Android mematikan proses app saat itu),
  saat app mulai lagi preferensi ikut dimatikan dan token dicabut dari server.

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

Cara termudah mendapatkan empat nilai `FIREBASE_*`: Firebase console →
*Project settings* → *General* → *Your apps* → tambahkan app Android dengan
package `com.kubus.work.droid` bila belum ada → unduh `google-services.json`,
lalu:

```bash
just firebase-env ~/Downloads/google-services.json
```

Tempel hasilnya ke `env/<flavor>.json`. Padanannya di dalam file:
`project_info.project_number` → SENDER_ID, `project_info.project_id` →
PROJECT_ID, `client[].client_info.mobilesdk_app_id` → APP_ID,
`client[].api_key[].current_key` → API_KEY.

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

## Menyiapkan Parse Server dan Parse Dashboard untuk push

Kredensial FCM **tidak bisa diatur dari Dashboard**; ia bagian dari konfigurasi
Parse Server. Dashboard dipakai untuk membaca kunci, memeriksa `_Installation`,
dan mengirim push uji.

### 1. Ambil service account Firebase

Firebase console → ikon gear → *Project settings* → tab *Service accounts* →
*Generate new private key*. Simpan JSON-nya di server, misalnya
`/config/firebase-service-account.json`. Pastikan *Firebase Cloud Messaging API
(V1)* aktif di tab *Cloud Messaging*.

### 2. Tambahkan `push` ke konfigurasi Parse Server

`config.json` (parse-server ≥ 5):

```json
{
  "appId": "APP_ID",
  "masterKey": "MASTER_KEY",
  "clientKey": "CLIENT_KEY",
  "serverURL": "https://parse.kubus.work/parse",
  "publicServerURL": "https://parse.kubus.work/parse",
  "push": {
    "android": {
      "firebaseServiceAccount": "/config/firebase-service-account.json"
    }
  }
}
```

Dengan image Docker `parseplatform/parse-server`, nilai yang sama bisa lewat
environment:

```yaml
services:
  parse:
    image: parseplatform/parse-server
    environment:
      PARSE_SERVER_APPLICATION_ID: APP_ID
      PARSE_SERVER_MASTER_KEY: MASTER_KEY
      PARSE_SERVER_CLIENT_KEY: CLIENT_KEY
      PARSE_SERVER_URL: https://parse.kubus.work/parse
      PARSE_SERVER_PUSH: '{"android":{"firebaseServiceAccount":"/config/firebase-service-account.json"}}'
    volumes:
      - ./firebase-service-account.json:/config/firebase-service-account.json:ro
```

Restart server, lalu cek `GET /parse/serverInfo` dengan header master key:
`features.push.immediatePush` harus `true`.

### 3. Parse Dashboard

`parse-dashboard-config.json`:

```json
{
  "apps": [{
    "serverURL": "https://parse.kubus.work/parse",
    "appId": "APP_ID",
    "masterKey": "MASTER_KEY",
    "appName": "droid"
  }]
}
```

Menu *Push* baru muncul setelah server melaporkan push aktif (langkah 2).
Kunci untuk app ada di *App Settings → Security & Keys*: `Application ID`
→ `PARSE_APP_ID`, `Client Key` → `PARSE_CLIENT_KEY` (kosongkan bila server
tidak mendefinisikan `clientKey`).

### 4. Verifikasi

1. Jalankan app (`just run`), sign in. Di Dashboard → *Core* → `_Installation`
   harus ada baris dengan `deviceToken`, `pushType: gcm`, `deviceType: android`,
   dan `userId`.
2. Dashboard → *Push* → *Send a new push*: audience *Everyone* (atau filter
   `deviceType = android`), isi pesan, kirim. Untuk membuka halaman tertentu,
   tambahkan key `route` di *Advanced/Data* dengan nilai misalnya `/notes`.
3. Atau lewat REST dengan master key (lihat perintah `curl` di atas).
4. Push tertarget: `where: {"userId": "<id>"}`.

Jika push tidak sampai: periksa log Parse Server (`verbose: true`), pastikan
package name app sama dengan yang terdaftar di Firebase, dan perangkat punya
Google Play Services.

### Catatan dari verifikasi nyata (Parse 9.10 + Waydroid)

- Parse mengirim isi push sebagai **JSON string di `data.data`**
  (`{"data":"{\"title\":..,\"alert\":..,\"route\":..}","push_id":..,"time":..}`).
  `ParseFcmPushService.toPushMessage` sudah membongkarnya; jangan mengandalkan
  `notification` dari FCM.
- Notifikasi hanya tampil bila izin `POST_NOTIFICATIONS` sudah diberikan.
  Pasang ulang APK mencabut izin itu, jadi aktifkan lagi lewat toggle
  "Terima notifikasi" di Pengaturan (atau `adb shell pm grant <package>
  android.permission.POST_NOTIFICATIONS` saat menguji). Pesan tetap diterima dan
  diproses app walau izin belum ada; hanya tampilannya yang diblokir sistem.
- Setiap pasang ulang membuat `_Installation` baru (store SDK ikut terhapus);
  baris lama dengan token kedaluwarsa menyumbang `numFailed`. Bersihkan lewat
  Dashboard atau `DELETE /parse/installations/<objectId>` dengan master key.
- `_PushStatus.numSent > 0` berarti FCM menerima pesan; bila perangkat tetap
  diam, periksa izin notifikasi dan apakah container Waydroid sedang `FROZEN`
  (lihat docs/waydroid.md).
