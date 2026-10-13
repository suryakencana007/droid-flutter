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
  String get tabExplore => 'Jelajah';

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
  String get exploreListLabel => 'Contoh daftar';

  @override
  String get exploreItemBody => 'Contoh item. Ganti dengan fitur nyata.';

  @override
  String get exploreFsd => 'Feature-Sliced Design';

  @override
  String get exploreFsdSub => 'Aturan layer dan slice';

  @override
  String get exploreUiKit => 'UI kit forui';

  @override
  String get exploreUiKitSub => 'Komponen dan tema';

  @override
  String get exploreWaydroid => 'Waydroid';

  @override
  String get exploreWaydroidSub => 'Uji di Android tanpa emulator';

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
}
