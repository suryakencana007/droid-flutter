# Task runner project. Daftar perintah: `just` atau `just --list`.

set shell := ["bash", "-euo", "pipefail", "-c"]

# IP Waydroid dibaca dari `waydroid status`; bisa dioverride: `just ip=10.0.0.5 run`
ip := `waydroid status 2>/dev/null | awk -F'\t' '/IP address/{print $2}' || true`
device := ip + ":5555"
app_id := "com.kubus.work.droid"

# Flavor: dev (default), staging, prod. Contoh: `just env=staging run`
env := "dev"
defines := "--dart-define-from-file=env/" + env + ".json"

# Tampilkan daftar recipe
default:
    @just --list --unsorted

# ---------- Setup ----------

# Pasang toolchain (mise), dependensi Dart, generate kode, dan git hook
setup:
    mise install
    flutter pub get
    just gen
    git config core.hooksPath .githooks

# Cek toolchain Flutter dan Android
doctor:
    flutter doctor

# ---------- Kualitas ----------

# Analisis statis
analyze:
    flutter analyze

# Semua test, termasuk uji aturan arsitektur FSD
test *args:
    flutter test {{defines}} {{args}}

# Hanya uji aturan import FSD
test-arch:
    flutter test test/architecture

# Format kode
fmt:
    dart format lib test tool

# Analyze + test, dipakai sebelum commit
check: analyze test

# Terapkan perbaikan otomatis dari analyzer
fix:
    dart fix --apply

# ---------- Build ----------

# Build APK debug (flavor dari `env=`)
build-apk:
    flutter build apk --debug {{defines}}

# Build APK release (flavor dari `env=`)
build-release:
    flutter build apk --release {{defines}}

# Bersihkan artefak build lalu pub get
clean:
    flutter clean
    flutter pub get

# ---------- Branding ----------

# Generate ikon launcher Android/iOS dari assets/brand
icons:
    dart run flutter_launcher_icons

# Generate splash native Android/iOS dari assets/brand
splash:
    dart run flutter_native_splash:create

# Ikon + splash sekaligus
brand: icons splash

# ---------- Codegen ----------

# Generate kode freezed / json_serializable (hasilnya di-commit)
gen:
    dart run build_runner build --delete-conflicting-outputs

# Generate terus-menerus saat file berubah
gen-watch:
    dart run build_runner watch --delete-conflicting-outputs

# ---------- i18n ----------

# Generate kelas lokalisasi dari lib/shared/l10n/arb/*.arb
l10n:
    flutter gen-l10n

# ---------- UI kit (forui) ----------

# Generate tema forui custom (interaktif), lihat docs/ui-kit.md
theme *args:
    dart run forui theme create {{args}}

# Generate boilerplate style/snippet forui: `just forui style create button`
forui *args:
    dart run forui {{args}}

# ---------- Template ----------

# Ganti identitas app: `just rename kasir_app com.perusahaan "Kasir App"`
rename name org title="":
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -n "{{title}}" ]; then
      dart run tool/rename.dart --name "{{name}}" --org "{{org}}" --title "{{title}}"
    else
      dart run tool/rename.dart --name "{{name}}" --org "{{org}}"
    fi
    flutter clean >/dev/null && flutter pub get
    # Nama package baru mengubah urutan import; rapikan agar lint tetap hijau.
    dart fix --apply

# ---------- FSD ----------

# Buat slice baru: `just slice feature auth` atau `just slice entity product ui model api`
slice layer name *segments:
    dart run tool/fsd.dart {{layer}} {{name}} {{segments}}

# ---------- Waydroid ----------

# Sambungkan adb ke Waydroid
connect:
    @test -n "{{ip}}" || { echo "Waydroid belum jalan: waydroid session start"; exit 1; }
    @adb connect {{device}} >/dev/null
    @adb devices | grep -q "{{device}}.*device$" || { echo "adb belum authorized; cek dialog di Waydroid lalu ulangi"; exit 1; }

# Putuskan adb dari Waydroid
disconnect:
    adb disconnect {{device}}

# Info device: versi Android, ABI, ukuran layar
info: connect
    @echo "Android : $(adb -s {{device}} shell getprop ro.build.version.release)"
    @echo "ABI     : $(adb -s {{device}} shell getprop ro.product.cpu.abi)"
    @echo "Layar   : $(adb -s {{device}} shell wm size | sed 's/.*: //')"

# Jalankan aplikasi di Waydroid (hot reload: r, hot restart: R, keluar: q)
run *args: info
    flutter run -d {{device}} {{defines}} {{args}}

# Jalankan aplikasi dalam mode release di Waydroid
run-release: info
    flutter run -d {{device}} --release {{defines}}

# Build lalu pasang APK debug ke Waydroid tanpa menjalankan sesi flutter
install: connect build-apk
    flutter install -d {{device}} --debug

# Hapus aplikasi dari Waydroid
uninstall: connect
    adb -s {{device}} uninstall {{app_id}}

# Buka aplikasi yang sudah terpasang
launch: connect
    adb -s {{device}} shell am start -n {{app_id}}/.MainActivity

# Hentikan aplikasi di Waydroid
stop: connect
    adb -s {{device}} shell am force-stop {{app_id}}

# Screenshot device ke file (default: screenshots/<timestamp>.png)
screenshot out="": connect
    #!/usr/bin/env bash
    set -euo pipefail
    out="{{out}}"
    if [ -z "$out" ]; then mkdir -p screenshots; out="screenshots/$(date +%Y%m%d-%H%M%S).png"; fi
    adb -s {{device}} shell 'screencap -p /sdcard/cap.png && base64 /sdcard/cap.png' 2>/dev/null | base64 -d > "$out"
    echo "$out"

# Tap koordinat layar: `just tap 453 62`
tap x y: connect
    adb -s {{device}} shell input tap {{x}} {{y}}

# Ketik teks ke field yang sedang fokus
type text: connect
    adb -s {{device}} shell input text '{{text}}'

# Kirim keyevent, contoh: `just key BACK`
key name: connect
    adb -s {{device}} shell input keyevent KEYCODE_{{name}}

# Integration test di Waydroid (flavor dari `env=`)
itest: connect
    flutter test integration_test -d {{device}} {{defines}}

# Logcat hanya untuk proses aplikasi
logcat: connect
    adb -s {{device}} logcat --pid="$(adb -s {{device}} shell pidof {{app_id}})"

# Shell adb interaktif ke Waydroid
shell: connect
    adb -s {{device}} shell
