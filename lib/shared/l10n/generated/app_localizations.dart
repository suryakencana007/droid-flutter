import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @onboardingSkip.
  ///
  /// In id, this message translates to:
  /// **'Lewati'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In id, this message translates to:
  /// **'Lanjut'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In id, this message translates to:
  /// **'Mulai'**
  String get onboardingStart;

  /// No description provided for @onboarding1Title.
  ///
  /// In id, this message translates to:
  /// **'Terstruktur sejak awal'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Body.
  ///
  /// In id, this message translates to:
  /// **'Feature-Sliced Design memisahkan halaman, fitur, entity, dan kode bersama dengan aturan import yang diuji otomatis.'**
  String get onboarding1Body;

  /// No description provided for @onboarding2Title.
  ///
  /// In id, this message translates to:
  /// **'UI kit siap pakai'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Body.
  ///
  /// In id, this message translates to:
  /// **'Komponen forui bergaya shadcn/ui, tema terang dan gelap, satu pintu masuk lewat shared/ui.'**
  String get onboarding2Body;

  /// No description provided for @onboarding3Title.
  ///
  /// In id, this message translates to:
  /// **'Langsung jalan'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Body.
  ///
  /// In id, this message translates to:
  /// **'Auth, onboarding, navigasi tab, dan pengaturan sudah ada. Ganti backend-nya, lalu bangun fiturmu.'**
  String get onboarding3Body;

  /// No description provided for @signInTitle.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get signInTitle;

  /// No description provided for @signInSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Selamat datang kembali di {appName}.'**
  String signInSubtitle(String appName);

  /// No description provided for @signInAction.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get signInAction;

  /// No description provided for @signInProcessing.
  ///
  /// In id, this message translates to:
  /// **'Memproses...'**
  String get signInProcessing;

  /// No description provided for @signInFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal masuk'**
  String get signInFailed;

  /// No description provided for @forgotPasswordLink.
  ///
  /// In id, this message translates to:
  /// **'Lupa password?'**
  String get forgotPasswordLink;

  /// No description provided for @noAccountLink.
  ///
  /// In id, this message translates to:
  /// **'Belum punya akun? Daftar'**
  String get noAccountLink;

  /// No description provided for @demoAccountHint.
  ///
  /// In id, this message translates to:
  /// **'Akun demo: {email} / {password}'**
  String demoAccountHint(String email, String password);

  /// No description provided for @emailLabel.
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In id, this message translates to:
  /// **'nama@contoh.com'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In id, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @signUpTitle.
  ///
  /// In id, this message translates to:
  /// **'Buat akun'**
  String get signUpTitle;

  /// No description provided for @signUpSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Gratis dan hanya butuh satu menit.'**
  String get signUpSubtitle;

  /// No description provided for @signUpAction.
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get signUpAction;

  /// No description provided for @signUpProcessing.
  ///
  /// In id, this message translates to:
  /// **'Memproses...'**
  String get signUpProcessing;

  /// No description provided for @signUpFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal mendaftar'**
  String get signUpFailed;

  /// No description provided for @haveAccountLink.
  ///
  /// In id, this message translates to:
  /// **'Sudah punya akun? Masuk'**
  String get haveAccountLink;

  /// No description provided for @nameLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In id, this message translates to:
  /// **'Nama lengkap'**
  String get nameHint;

  /// No description provided for @passwordMinHint.
  ///
  /// In id, this message translates to:
  /// **'Minimal 8 karakter'**
  String get passwordMinHint;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In id, this message translates to:
  /// **'Ulangi password'**
  String get confirmPasswordLabel;

  /// No description provided for @passwordMismatch.
  ///
  /// In id, this message translates to:
  /// **'Password tidak sama'**
  String get passwordMismatch;

  /// No description provided for @forgotTitle.
  ///
  /// In id, this message translates to:
  /// **'Lupa password'**
  String get forgotTitle;

  /// No description provided for @forgotSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Masukkan email, kami kirim tautan untuk mengatur ulang.'**
  String get forgotSubtitle;

  /// No description provided for @forgotSend.
  ///
  /// In id, this message translates to:
  /// **'Kirim tautan reset'**
  String get forgotSend;

  /// No description provided for @forgotSending.
  ///
  /// In id, this message translates to:
  /// **'Mengirim...'**
  String get forgotSending;

  /// No description provided for @forgotFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal mengirim'**
  String get forgotFailed;

  /// No description provided for @forgotSentTitle.
  ///
  /// In id, this message translates to:
  /// **'Periksa email kamu'**
  String get forgotSentTitle;

  /// No description provided for @forgotSentBody.
  ///
  /// In id, this message translates to:
  /// **'Jika {email} terdaftar, tautan reset password sudah dikirim.'**
  String forgotSentBody(String email);

  /// No description provided for @backToSignIn.
  ///
  /// In id, this message translates to:
  /// **'Kembali ke masuk'**
  String get backToSignIn;

  /// No description provided for @tabHome.
  ///
  /// In id, this message translates to:
  /// **'Beranda'**
  String get tabHome;

  /// No description provided for @tabProfile.
  ///
  /// In id, this message translates to:
  /// **'Profil'**
  String get tabProfile;

  /// No description provided for @homeGreeting.
  ///
  /// In id, this message translates to:
  /// **'Halo, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeGuest.
  ///
  /// In id, this message translates to:
  /// **'teman'**
  String get homeGuest;

  /// No description provided for @homeDescription.
  ///
  /// In id, this message translates to:
  /// **'Halaman ini merakit widget, feature, dan entity dari layer di bawahnya.'**
  String get homeDescription;

  /// No description provided for @showToast.
  ///
  /// In id, this message translates to:
  /// **'Tampilkan toast'**
  String get showToast;

  /// No description provided for @toastTitle.
  ///
  /// In id, this message translates to:
  /// **'UI kit: forui'**
  String get toastTitle;

  /// No description provided for @toastBody.
  ///
  /// In id, this message translates to:
  /// **'Komponen dipakai lewat shared/ui.'**
  String get toastBody;

  /// No description provided for @settingsTitle.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Tema, bahasa, dan info aplikasi'**
  String get settingsSubtitle;

  /// No description provided for @signOut.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get signOut;

  /// No description provided for @signingOut.
  ///
  /// In id, this message translates to:
  /// **'Keluar...'**
  String get signingOut;

  /// No description provided for @signOutConfirmTitle.
  ///
  /// In id, this message translates to:
  /// **'Keluar dari akun?'**
  String get signOutConfirmTitle;

  /// No description provided for @signOutConfirmBody.
  ///
  /// In id, this message translates to:
  /// **'Kamu perlu masuk lagi untuk menggunakan aplikasi.'**
  String get signOutConfirmBody;

  /// No description provided for @cancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get cancel;

  /// No description provided for @themeLabel.
  ///
  /// In id, this message translates to:
  /// **'Tema'**
  String get themeLabel;

  /// No description provided for @themeDescription.
  ///
  /// In id, this message translates to:
  /// **'Berlaku di seluruh aplikasi dan diingat.'**
  String get themeDescription;

  /// No description provided for @themeSystem.
  ///
  /// In id, this message translates to:
  /// **'Ikuti sistem'**
  String get themeSystem;

  /// No description provided for @themeSystemSub.
  ///
  /// In id, this message translates to:
  /// **'Mengikuti pengaturan perangkat'**
  String get themeSystemSub;

  /// No description provided for @themeLight.
  ///
  /// In id, this message translates to:
  /// **'Terang'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In id, this message translates to:
  /// **'Gelap'**
  String get themeDark;

  /// No description provided for @lightMode.
  ///
  /// In id, this message translates to:
  /// **'Mode terang'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In id, this message translates to:
  /// **'Mode gelap'**
  String get darkMode;

  /// No description provided for @languageLabel.
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get languageLabel;

  /// No description provided for @languageDescription.
  ///
  /// In id, this message translates to:
  /// **'Bahasa tampilan aplikasi.'**
  String get languageDescription;

  /// No description provided for @languageSystem.
  ///
  /// In id, this message translates to:
  /// **'Ikuti sistem'**
  String get languageSystem;

  /// No description provided for @languageId.
  ///
  /// In id, this message translates to:
  /// **'Indonesia'**
  String get languageId;

  /// No description provided for @languageEn.
  ///
  /// In id, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @aboutLabel.
  ///
  /// In id, this message translates to:
  /// **'Tentang'**
  String get aboutLabel;

  /// No description provided for @appLabel.
  ///
  /// In id, this message translates to:
  /// **'Aplikasi'**
  String get appLabel;

  /// No description provided for @versionLabel.
  ///
  /// In id, this message translates to:
  /// **'Versi'**
  String get versionLabel;

  /// No description provided for @notFoundMessage.
  ///
  /// In id, this message translates to:
  /// **'Halaman tidak ditemukan: {uri}'**
  String notFoundMessage(String uri);

  /// No description provided for @backHome.
  ///
  /// In id, this message translates to:
  /// **'Kembali ke beranda'**
  String get backHome;

  /// No description provided for @validationRequired.
  ///
  /// In id, this message translates to:
  /// **'Wajib diisi'**
  String get validationRequired;

  /// No description provided for @validationEmail.
  ///
  /// In id, this message translates to:
  /// **'Format email tidak valid'**
  String get validationEmail;

  /// No description provided for @validationMinLength.
  ///
  /// In id, this message translates to:
  /// **'Minimal {count} karakter'**
  String validationMinLength(int count);

  /// No description provided for @errorGeneric.
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan. Coba lagi.'**
  String get errorGeneric;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In id, this message translates to:
  /// **'Email atau password salah.'**
  String get authInvalidCredentials;

  /// No description provided for @authEmailInUse.
  ///
  /// In id, this message translates to:
  /// **'Email sudah terdaftar.'**
  String get authEmailInUse;

  /// No description provided for @errorNetwork.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada koneksi internet.'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In id, this message translates to:
  /// **'Server tidak merespons. Coba lagi.'**
  String get errorTimeout;

  /// No description provided for @errorUnauthorized.
  ///
  /// In id, this message translates to:
  /// **'Sesi berakhir, silakan masuk lagi.'**
  String get errorUnauthorized;

  /// No description provided for @errorNotFound.
  ///
  /// In id, this message translates to:
  /// **'Data tidak ditemukan.'**
  String get errorNotFound;

  /// No description provided for @errorServer.
  ///
  /// In id, this message translates to:
  /// **'Server sedang bermasalah. Coba beberapa saat lagi.'**
  String get errorServer;

  /// No description provided for @retry.
  ///
  /// In id, this message translates to:
  /// **'Coba lagi'**
  String get retry;

  /// No description provided for @offlineBanner.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada koneksi internet'**
  String get offlineBanner;

  /// No description provided for @emptyTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum ada data'**
  String get emptyTitle;

  /// No description provided for @emptyBody.
  ///
  /// In id, this message translates to:
  /// **'Data akan muncul di sini.'**
  String get emptyBody;

  /// No description provided for @tabNotes.
  ///
  /// In id, this message translates to:
  /// **'Catatan'**
  String get tabNotes;

  /// No description provided for @notesTitle.
  ///
  /// In id, this message translates to:
  /// **'Catatan'**
  String get notesTitle;

  /// No description provided for @noteNew.
  ///
  /// In id, this message translates to:
  /// **'Catatan baru'**
  String get noteNew;

  /// No description provided for @noteEdit.
  ///
  /// In id, this message translates to:
  /// **'Ubah catatan'**
  String get noteEdit;

  /// No description provided for @noteTitleLabel.
  ///
  /// In id, this message translates to:
  /// **'Judul'**
  String get noteTitleLabel;

  /// No description provided for @noteTitleHint.
  ///
  /// In id, this message translates to:
  /// **'Judul catatan'**
  String get noteTitleHint;

  /// No description provided for @noteBodyLabel.
  ///
  /// In id, this message translates to:
  /// **'Isi'**
  String get noteBodyLabel;

  /// No description provided for @noteBodyHint.
  ///
  /// In id, this message translates to:
  /// **'Tulis sesuatu...'**
  String get noteBodyHint;

  /// No description provided for @save.
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get save;

  /// No description provided for @saving.
  ///
  /// In id, this message translates to:
  /// **'Menyimpan...'**
  String get saving;

  /// No description provided for @delete.
  ///
  /// In id, this message translates to:
  /// **'Hapus'**
  String get delete;

  /// No description provided for @deleting.
  ///
  /// In id, this message translates to:
  /// **'Menghapus...'**
  String get deleting;

  /// No description provided for @edit.
  ///
  /// In id, this message translates to:
  /// **'Ubah'**
  String get edit;

  /// No description provided for @noteDeleteConfirmTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus catatan?'**
  String get noteDeleteConfirmTitle;

  /// No description provided for @noteDeleteConfirmBody.
  ///
  /// In id, this message translates to:
  /// **'Catatan yang dihapus tidak bisa dikembalikan.'**
  String get noteDeleteConfirmBody;

  /// No description provided for @notesEmptyTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum ada catatan'**
  String get notesEmptyTitle;

  /// No description provided for @notesEmptyBody.
  ///
  /// In id, this message translates to:
  /// **'Tekan + untuk membuat catatan pertama.'**
  String get notesEmptyBody;

  /// No description provided for @noteSaved.
  ///
  /// In id, this message translates to:
  /// **'Catatan disimpan'**
  String get noteSaved;

  /// No description provided for @noteDeleted.
  ///
  /// In id, this message translates to:
  /// **'Catatan dihapus'**
  String get noteDeleted;

  /// No description provided for @updatedAt.
  ///
  /// In id, this message translates to:
  /// **'Diperbarui {date}'**
  String updatedAt(String date);

  /// No description provided for @loadMoreFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat halaman berikutnya'**
  String get loadMoreFailed;

  /// No description provided for @permissionsLabel.
  ///
  /// In id, this message translates to:
  /// **'Izin'**
  String get permissionsLabel;

  /// No description provided for @permissionsDescription.
  ///
  /// In id, this message translates to:
  /// **'Status izin sistem untuk fitur yang membutuhkannya.'**
  String get permissionsDescription;

  /// No description provided for @permissionNotifications.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi'**
  String get permissionNotifications;

  /// No description provided for @permissionNotificationsBody.
  ///
  /// In id, this message translates to:
  /// **'Dipakai untuk mengabarkan pembaruan penting. Kamu bisa mematikannya kapan saja.'**
  String get permissionNotificationsBody;

  /// No description provided for @permissionCamera.
  ///
  /// In id, this message translates to:
  /// **'Kamera'**
  String get permissionCamera;

  /// No description provided for @permissionCameraBody.
  ///
  /// In id, this message translates to:
  /// **'Dipakai untuk memotret lampiran. Foto tidak dikirim ke mana pun tanpa persetujuanmu.'**
  String get permissionCameraBody;

  /// No description provided for @permissionLocation.
  ///
  /// In id, this message translates to:
  /// **'Lokasi'**
  String get permissionLocation;

  /// No description provided for @permissionLocationBody.
  ///
  /// In id, this message translates to:
  /// **'Dipakai untuk menampilkan konten di sekitarmu saat aplikasi dibuka.'**
  String get permissionLocationBody;

  /// No description provided for @permissionGranted.
  ///
  /// In id, this message translates to:
  /// **'Diizinkan'**
  String get permissionGranted;

  /// No description provided for @permissionDenied.
  ///
  /// In id, this message translates to:
  /// **'Ditolak'**
  String get permissionDenied;

  /// No description provided for @permissionPermanentlyDenied.
  ///
  /// In id, this message translates to:
  /// **'Ditolak permanen'**
  String get permissionPermanentlyDenied;

  /// No description provided for @permissionUnknown.
  ///
  /// In id, this message translates to:
  /// **'Belum diminta'**
  String get permissionUnknown;

  /// No description provided for @permissionContinue.
  ///
  /// In id, this message translates to:
  /// **'Lanjutkan'**
  String get permissionContinue;

  /// No description provided for @permissionDeniedTitle.
  ///
  /// In id, this message translates to:
  /// **'Izin ditolak'**
  String get permissionDeniedTitle;

  /// No description provided for @permissionDeniedBody.
  ///
  /// In id, this message translates to:
  /// **'Aktifkan izin ini lewat pengaturan sistem.'**
  String get permissionDeniedBody;

  /// No description provided for @openSettings.
  ///
  /// In id, this message translates to:
  /// **'Buka pengaturan'**
  String get openSettings;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
