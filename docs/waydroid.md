# Menjalankan di Waydroid

Waydroid dipakai sebagai device Android di mesin Linux tanpa emulator.
Diverifikasi jalan dengan Flutter 3.47.7 pada Waydroid (Android 13, x86_64).

## Sambungkan adb

```bash
waydroid status                      # Session dan Container harus RUNNING
adb connect 192.168.240.112:5555     # IP default Waydroid, cek di waydroid status
adb devices                          # harus berstatus "device"
```

Kalau statusnya `unauthorized`, jalankan `adb kill-server` lalu `adb connect`
lagi, dan terima dialog "Allow USB debugging" jika muncul di jendela Waydroid.

## Jalankan aplikasi

```bash
flutter run -d 192.168.240.112:5555
```

Tekan `r` untuk hot reload, `R` untuk hot restart, `q` untuk keluar.

## Screenshot dari device

`adb exec-out screencap` di Waydroid menghasilkan file rusak karena ada baris
peringatan `/vendor/etc/hwdata/amdgpu.ids` di stdout. Gunakan jalur ini:

```bash
adb shell 'screencap -p /sdcard/cap.png && base64 /sdcard/cap.png' | base64 -d > cap.png
```

## Simulasi input

```bash
adb shell wm size                    # 480x1000 pada konfigurasi default
adb shell input tap 453 62           # contoh: tombol tema di app bar
adb shell input text "halo"
adb shell input keyevent KEYCODE_BACK
```

Tap pertama setelah aplikasi baru diluncurkan kadang tidak tercatat.
Ulangi tap sebelum menyimpulkan ada bug.

## Catatan

- Waydroid berjalan dalam night mode, jadi uji jalur tema terang secara eksplisit.
- Jendela Waydroid di Hyprland bersifat floating; screenshot sisi host dengan
  `grim -g` bisa menampilkan frame lama. Lebih andal pakai screencap dari device.
- Log runtime: `adb logcat --pid=$(adb shell pidof com.kubus.work.droid)`.
