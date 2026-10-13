// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get onboardingSkip => 'Lewati';

  @override
  String get onboardingNext => 'Lanjut';

  @override
  String get onboardingStart => 'Mulai';

  @override
  String get onboarding1Title => 'Terstruktur sejak awal';

  @override
  String get onboarding1Body =>
      'Feature-Sliced Design memisahkan halaman, fitur, entity, dan kode bersama dengan aturan import yang diuji otomatis.';

  @override
  String get onboarding2Title => 'UI kit siap pakai';

  @override
  String get onboarding2Body =>
      'Komponen forui bergaya shadcn/ui, tema terang dan gelap, satu pintu masuk lewat shared/ui.';

  @override
  String get onboarding3Title => 'Langsung jalan';

  @override
  String get onboarding3Body =>
      'Auth, onboarding, navigasi tab, dan pengaturan sudah ada. Ganti backend-nya, lalu bangun fiturmu.';

  @override
  String get signInTitle => 'Masuk';

  @override
  String signInSubtitle(String appName) {
    return 'Selamat datang kembali di $appName.';
  }

  @override
  String get signInAction => 'Masuk';

  @override
  String get signInProcessing => 'Memproses...';

  @override
  String get signInFailed => 'Gagal masuk';

  @override
  String get forgotPasswordLink => 'Lupa password?';

  @override
  String get noAccountLink => 'Belum punya akun? Daftar';

  @override
  String demoAccountHint(String email, String password) {
    return 'Akun demo: $email / $password';
  }

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'nama@contoh.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get signUpTitle => 'Buat akun';

  @override
  String get signUpSubtitle => 'Gratis dan hanya butuh satu menit.';

  @override
  String get signUpAction => 'Daftar';

  @override
  String get signUpProcessing => 'Memproses...';

  @override
  String get signUpFailed => 'Gagal mendaftar';

  @override
  String get haveAccountLink => 'Sudah punya akun? Masuk';

  @override
  String get nameLabel => 'Nama';

  @override
  String get nameHint => 'Nama lengkap';

  @override
  String get passwordMinHint => 'Minimal 8 karakter';

  @override
  String get confirmPasswordLabel => 'Ulangi password';

  @override
  String get passwordMismatch => 'Password tidak sama';

  @override
  String get forgotTitle => 'Lupa password';

  @override
  String get forgotSubtitle =>
      'Masukkan email, kami kirim tautan untuk mengatur ulang.';

  @override
  String get forgotSend => 'Kirim tautan reset';

  @override
  String get forgotSending => 'Mengirim...';

  @override
  String get forgotFailed => 'Gagal mengirim';

  @override
  String get forgotSentTitle => 'Periksa email kamu';

  @override
  String forgotSentBody(String email) {
    return 'Jika $email terdaftar, tautan reset password sudah dikirim.';
  }

  @override
  String get backToSignIn => 'Kembali ke masuk';

  @override
  String get tabHome => 'Beranda';

  @override
  String get tabProfile => 'Profil';

  @override
  String homeGreeting(String name) {
    return 'Halo, $name';
  }

  @override
  String get homeGuest => 'teman';

  @override
  String get homeDescription =>
      'Halaman ini merakit widget, feature, dan entity dari layer di bawahnya.';

  @override
  String get showToast => 'Tampilkan toast';

  @override
  String get toastTitle => 'UI kit: forui';

  @override
  String get toastBody => 'Komponen dipakai lewat shared/ui.';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsSubtitle => 'Tema, bahasa, dan info aplikasi';

  @override
  String get signOut => 'Keluar';

  @override
  String get signingOut => 'Keluar...';

  @override
  String get signOutConfirmTitle => 'Keluar dari akun?';

  @override
  String get signOutConfirmBody =>
      'Kamu perlu masuk lagi untuk menggunakan aplikasi.';

  @override
  String get cancel => 'Batal';

  @override
  String get themeLabel => 'Tema';

  @override
  String get themeDescription => 'Berlaku di seluruh aplikasi dan diingat.';

  @override
  String get themeSystem => 'Ikuti sistem';

  @override
  String get themeSystemSub => 'Mengikuti pengaturan perangkat';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get lightMode => 'Mode terang';

  @override
  String get darkMode => 'Mode gelap';

  @override
  String get languageLabel => 'Bahasa';

  @override
  String get languageDescription => 'Bahasa tampilan aplikasi.';

  @override
  String get languageSystem => 'Ikuti sistem';

  @override
  String get languageId => 'Indonesia';

  @override
  String get languageEn => 'English';

  @override
  String get aboutLabel => 'Tentang';

  @override
  String get appLabel => 'Aplikasi';

  @override
  String get versionLabel => 'Versi';

  @override
  String notFoundMessage(String uri) {
    return 'Halaman tidak ditemukan: $uri';
  }

  @override
  String get backHome => 'Kembali ke beranda';

  @override
  String get validationRequired => 'Wajib diisi';

  @override
  String get validationEmail => 'Format email tidak valid';

  @override
  String validationMinLength(int count) {
    return 'Minimal $count karakter';
  }

  @override
  String get errorGeneric => 'Terjadi kesalahan. Coba lagi.';

  @override
  String get authInvalidCredentials => 'Email atau password salah.';

  @override
  String get authEmailInUse => 'Email sudah terdaftar.';

  @override
  String get errorNetwork => 'Tidak ada koneksi internet.';

  @override
  String get errorTimeout => 'Server tidak merespons. Coba lagi.';

  @override
  String get errorUnauthorized => 'Sesi berakhir, silakan masuk lagi.';

  @override
  String get errorNotFound => 'Data tidak ditemukan.';

  @override
  String get errorServer =>
      'Server sedang bermasalah. Coba beberapa saat lagi.';

  @override
  String get retry => 'Coba lagi';

  @override
  String get offlineBanner => 'Tidak ada koneksi internet';

  @override
  String get emptyTitle => 'Belum ada data';

  @override
  String get emptyBody => 'Data akan muncul di sini.';

  @override
  String get tabNotes => 'Catatan';

  @override
  String get notesTitle => 'Catatan';

  @override
  String get noteNew => 'Catatan baru';

  @override
  String get noteEdit => 'Ubah catatan';

  @override
  String get noteTitleLabel => 'Judul';

  @override
  String get noteTitleHint => 'Judul catatan';

  @override
  String get noteBodyLabel => 'Isi';

  @override
  String get noteBodyHint => 'Tulis sesuatu...';

  @override
  String get save => 'Simpan';

  @override
  String get saving => 'Menyimpan...';

  @override
  String get delete => 'Hapus';

  @override
  String get deleting => 'Menghapus...';

  @override
  String get edit => 'Ubah';

  @override
  String get noteDeleteConfirmTitle => 'Hapus catatan?';

  @override
  String get noteDeleteConfirmBody =>
      'Catatan yang dihapus tidak bisa dikembalikan.';

  @override
  String get notesEmptyTitle => 'Belum ada catatan';

  @override
  String get notesEmptyBody => 'Tekan + untuk membuat catatan pertama.';

  @override
  String get noteSaved => 'Catatan disimpan';

  @override
  String get noteDeleted => 'Catatan dihapus';

  @override
  String updatedAt(String date) {
    return 'Diperbarui $date';
  }

  @override
  String get loadMoreFailed => 'Gagal memuat halaman berikutnya';

  @override
  String get permissionsLabel => 'Izin';

  @override
  String get permissionsDescription =>
      'Status izin sistem untuk fitur yang membutuhkannya.';

  @override
  String get permissionNotifications => 'Notifikasi';

  @override
  String get permissionNotificationsBody =>
      'Dipakai untuk mengabarkan pembaruan penting. Kamu bisa mematikannya kapan saja.';

  @override
  String get permissionCamera => 'Kamera';

  @override
  String get permissionCameraBody =>
      'Dipakai untuk memotret lampiran. Foto tidak dikirim ke mana pun tanpa persetujuanmu.';

  @override
  String get permissionLocation => 'Lokasi';

  @override
  String get permissionLocationBody =>
      'Dipakai untuk menampilkan konten di sekitarmu saat aplikasi dibuka.';

  @override
  String get permissionGranted => 'Diizinkan';

  @override
  String get permissionDenied => 'Ditolak';

  @override
  String get permissionPermanentlyDenied => 'Ditolak permanen';

  @override
  String get permissionUnknown => 'Belum diminta';

  @override
  String get permissionContinue => 'Lanjutkan';

  @override
  String get permissionDeniedTitle => 'Izin ditolak';

  @override
  String get permissionDeniedBody =>
      'Aktifkan izin ini lewat pengaturan sistem.';

  @override
  String get openSettings => 'Buka pengaturan';

  @override
  String get notificationsLabel => 'Notifikasi';

  @override
  String get notificationsToggle => 'Terima notifikasi';

  @override
  String get notificationsToggleBody =>
      'Kabar penting dari aplikasi. Butuh izin notifikasi sistem.';

  @override
  String get sendTestNotification => 'Kirim notifikasi uji';

  @override
  String testNotificationTitle(String appName) {
    return 'Halo dari $appName';
  }

  @override
  String get testNotificationBody => 'Ketuk untuk membuka catatan.';

  @override
  String get notificationChannelName => 'Umum';

  @override
  String get notificationChannelDescription => 'Notifikasi umum aplikasi';

  @override
  String get featureFlagsLabel => 'Feature flags';

  @override
  String featureFlagsDescription(String source) {
    return 'Nilai aktif dari $source.';
  }

  @override
  String get featureFlagsEmpty => 'Tidak ada flag.';

  @override
  String get betaBadge => 'Beta';

  @override
  String get refresh => 'Muat ulang';

  @override
  String get appLockLabel => 'Kunci aplikasi';

  @override
  String get appLockToggle => 'Kunci dengan biometrik';

  @override
  String get appLockToggleBody =>
      'Minta sidik jari, wajah, atau PIN perangkat saat kembali ke aplikasi.';

  @override
  String get appLockUnavailable =>
      'Perangkat ini belum punya biometrik atau PIN.';

  @override
  String get lockTitle => 'Aplikasi terkunci';

  @override
  String get lockBody => 'Buka dengan biometrik atau PIN perangkat.';

  @override
  String get unlock => 'Buka';

  @override
  String unlockReason(String appName) {
    return 'Buka $appName';
  }

  @override
  String get unlockFailed => 'Verifikasi gagal. Coba lagi.';

  @override
  String get editProfileTitle => 'Ubah profil';

  @override
  String get editProfileSubtitle => 'Nama dan data akun';

  @override
  String get changePasswordTitle => 'Ganti password';

  @override
  String get changePasswordSubtitle => 'Perbarui password akun';

  @override
  String get currentPasswordLabel => 'Password saat ini';

  @override
  String get newPasswordLabel => 'Password baru';

  @override
  String get profileSaved => 'Profil disimpan';

  @override
  String get passwordChanged => 'Password diganti';

  @override
  String get editProfileFailed => 'Gagal menyimpan profil';

  @override
  String get changePasswordFailed => 'Gagal mengganti password';

  @override
  String get authWrongPassword => 'Password saat ini salah.';
}
