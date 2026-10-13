import 'package:droid/app/index.dart';
import 'package:droid/entities/note/index.dart';
import 'package:droid/entities/user/index.dart';
import 'package:droid/features/app_lock/index.dart';
import 'package:droid/features/delete_note/index.dart';
import 'package:droid/features/manage_notifications/index.dart';
import 'package:droid/features/sign_out/index.dart';
import 'package:droid/features/toggle_theme/index.dart';
import 'package:droid/pages/feature_flags/index.dart';
import 'package:droid/pages/lock/index.dart';
import 'package:droid/pages/settings/index.dart';
import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// App dengan storage in-memory dan FakeAuthApi tanpa delay. Bahasa
/// default test adalah Indonesia (`locale` di prefs) agar finder teks stabil
/// walau locale platform test adalah en_US.
Widget buildApp({
  Map<String, Object> prefs = const {},
  Map<String, String> secrets = const {},
  FakeAuthApi? authApi,
  String? locale = 'id',
  bool online = true,
}) {
  return ProviderScope(
    overrides: [
      pushServiceProvider.overrideWithValue(const NoopPushService()),
      deviceAuthenticatorProvider.overrideWithValue(
        MemoryAuthenticator(available: false),
      ),
      isOnlineProvider.overrideWith((ref) => Stream.value(online)),
      keyValueStoreProvider.overrideWithValue(
        MemoryKeyValueStore({'locale': ?locale, ...prefs}),
      ),
      secureStoreProvider.overrideWithValue(MemorySecureStore(secrets)),
      authApiProvider.overrideWithValue(
        authApi ?? FakeAuthApi(latency: Duration.zero),
      ),
    ],
    child: const App(),
  );
}

/// Viewport test bawaan 800x600 melewati breakpoint sidebar (640), jadi test
/// alur ponsel memakai ukuran ponsel secara eksplisit.
void usePhoneViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(480, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Future<void> pumpPhone(WidgetTester tester, Widget app) async {
  usePhoneViewport(tester);
  await tester.pumpWidget(app);
}

Future<void> enterField(WidgetTester tester, int index, String text) async {
  await tester.enterText(find.byType(EditableText).at(index), text);
  await tester.pump();
}

void main() {
  notificationPermissionTests();
  notesTests();
  flagTests();
  appLockTests();
  profileTests();
  responsiveTests();

  testWidgets('alur pertama: onboarding → sign in → home → sign out', (
    tester,
  ) async {
    await pumpPhone(tester, buildApp());
    await tester.pumpAndSettle();

    // Onboarding tampil karena flag belum ada.
    expect(find.text('Terstruktur sejak awal'), findsOneWidget);
    expect(find.byType(FTheme), findsOneWidget);

    await tester.tap(find.text('Lewati'));
    await tester.pumpAndSettle();

    // Sign in dengan password salah menampilkan FAlert.
    expect(find.text('Masuk'), findsWidgets);
    await enterField(tester, 0, FakeAuthApi.demoEmail);
    await enterField(tester, 1, 'salah');
    await tester.tap(find.widgetWithText(FButton, 'Masuk'));
    await tester.pumpAndSettle();
    expect(find.byType(FAlert), findsOneWidget);
    expect(find.text('Email atau password salah.'), findsOneWidget);

    // Kredensial demo masuk ke home dengan sapaan.
    await enterField(tester, 1, FakeAuthApi.demoPassword);
    await tester.tap(find.widgetWithText(FButton, 'Masuk'));
    await tester.pumpAndSettle();
    expect(find.text('Halo, Demo'), findsOneWidget);
    expect(find.byType(FBottomNavigationBar), findsOneWidget);

    // Pindah ke Profil lalu sign out lewat dialog konfirmasi.
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text(FakeAuthApi.demoEmail), findsOneWidget);

    await tester.tap(find.byType(SignOutButton));
    await tester.pumpAndSettle();
    expect(find.text('Keluar dari akun?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FButton, 'Keluar').last);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(FButton, 'Masuk'), findsOneWidget);
  });

  testWidgets('token tersimpan langsung ke home tanpa onboarding', (
    tester,
  ) async {
    final api = FakeAuthApi(latency: Duration.zero);
    // runAsync: FakeAuthApi memakai Future.delayed yang tidak jalan di zona
    // fake-async test sebelum ada pump.
    final session = await tester.runAsync(
      () => api.signIn(
        email: FakeAuthApi.demoEmail,
        password: FakeAuthApi.demoPassword,
      ),
    );

    await pumpPhone(
      tester,
      buildApp(
        prefs: {'onboarding_done': true},
        secrets: {'auth_token': session!.token},
        authApi: api,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Halo, Demo'), findsOneWidget);
  });

  testWidgets('sign up membuat akun dan masuk', (tester) async {
    await pumpPhone(tester, buildApp(prefs: {'onboarding_done': true}));
    await tester.pumpAndSettle();

    // Tautan berada di bawah lipatan viewport test (800x600), gulir dulu.
    await tester.ensureVisible(find.text('Belum punya akun? Daftar'));
    await tester.tap(find.text('Belum punya akun? Daftar'));
    await tester.pumpAndSettle();
    expect(find.text('Buat akun'), findsOneWidget);

    await enterField(tester, 0, 'Surya');
    await enterField(tester, 1, 'surya@contoh.com');
    await enterField(tester, 2, 'rahasia123');
    await enterField(tester, 3, 'beda');
    await tester.ensureVisible(find.widgetWithText(FButton, 'Daftar'));
    await tester.tap(find.widgetWithText(FButton, 'Daftar'));
    await tester.pumpAndSettle();
    expect(find.text('Password tidak sama'), findsOneWidget);

    await enterField(tester, 3, 'rahasia123');
    await tester.ensureVisible(find.widgetWithText(FButton, 'Daftar'));
    await tester.tap(find.widgetWithText(FButton, 'Daftar'));
    await tester.pumpAndSettle();
    expect(find.text('Halo, Surya'), findsOneWidget);
  });

  testWidgets('pilihan tema di pengaturan disimpan', (tester) async {
    final api = FakeAuthApi(latency: Duration.zero);
    final session = await tester.runAsync(
      () => api.signIn(
        email: FakeAuthApi.demoEmail,
        password: FakeAuthApi.demoPassword,
      ),
    );
    final prefs = MemoryKeyValueStore({
      'onboarding_done': true,
      'locale': 'id',
    });

    await pumpPhone(
      tester,
      ProviderScope(
        overrides: [
          pushServiceProvider.overrideWithValue(const NoopPushService()),
          isOnlineProvider.overrideWith((ref) => Stream.value(true)),
          keyValueStoreProvider.overrideWithValue(prefs),
          secureStoreProvider.overrideWithValue(
            MemorySecureStore({'auth_token': session!.token}),
          ),
          authApiProvider.overrideWithValue(api),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pengaturan'));
    await tester.pumpAndSettle();
    expect(find.byType(ThemeModeSelector), findsOneWidget);

    await tester.tap(find.text('Gelap'));
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);
    expect(await prefs.getString('theme_mode'), 'dark');
  });

  testWidgets('analytics mencatat event sign in, user, dan screen', (
    tester,
  ) async {
    final analytics = MemoryAnalytics();
    await pumpPhone(
      tester,
      ProviderScope(
        overrides: [
          pushServiceProvider.overrideWithValue(const NoopPushService()),
          deviceAuthenticatorProvider.overrideWithValue(
            MemoryAuthenticator(available: false),
          ),
          analyticsProvider.overrideWithValue(analytics),
          isOnlineProvider.overrideWith((ref) => Stream.value(true)),
          keyValueStoreProvider.overrideWithValue(
            MemoryKeyValueStore({'onboarding_done': true, 'locale': 'id'}),
          ),
          secureStoreProvider.overrideWithValue(MemorySecureStore()),
          authApiProvider.overrideWithValue(
            FakeAuthApi(latency: Duration.zero),
          ),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
    await enterField(tester, 0, FakeAuthApi.demoEmail);
    await enterField(tester, 1, FakeAuthApi.demoPassword);
    await tester.tap(find.widgetWithText(FButton, 'Masuk'));
    await tester.pumpAndSettle();

    expect(analytics.events.map((e) => e.$1), contains('sign_in'));
    expect(analytics.userId, '1');
    expect(analytics.screens, containsAll([AppRoutes.signIn, AppRoutes.home]));
  });

  testWidgets('izin: dialog penjelasan lalu status berubah menjadi diizinkan', (
    tester,
  ) async {
    final permissions = MemoryPermissionService(
      initial: {AppPermission.camera: PermissionResult.denied},
    );
    final api = FakeAuthApi(latency: Duration.zero);
    final session = await tester.runAsync(
      () => api.signIn(
        email: FakeAuthApi.demoEmail,
        password: FakeAuthApi.demoPassword,
      ),
    );
    await pumpPhone(
      tester,
      ProviderScope(
        overrides: [
          pushServiceProvider.overrideWithValue(const NoopPushService()),
          deviceAuthenticatorProvider.overrideWithValue(
            MemoryAuthenticator(available: false),
          ),
          permissionServiceProvider.overrideWithValue(permissions),
          isOnlineProvider.overrideWith((ref) => Stream.value(true)),
          keyValueStoreProvider.overrideWithValue(
            MemoryKeyValueStore({'onboarding_done': true, 'locale': 'id'}),
          ),
          secureStoreProvider.overrideWithValue(
            MemorySecureStore({'auth_token': session!.token}),
          ),
          authApiProvider.overrideWithValue(api),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pengaturan'));
    await tester.pumpAndSettle();

    final settingsList = find.descendant(
      of: find.byType(SettingsPage),
      matching: find.byType(Scrollable),
    );
    await tester.scrollUntilVisible(
      find.text('Kamera'),
      200,
      scrollable: settingsList.first,
    );
    await tester.drag(settingsList.first, const Offset(0, -200));
    await tester.pumpAndSettle();
    expect(find.text('Ditolak'), findsOneWidget);
    await tester.tap(find.text('Kamera'));
    await tester.pumpAndSettle();
    expect(find.text('Lanjutkan'), findsOneWidget); // dialog penjelasan
    await tester.tap(find.text('Lanjutkan'));
    await tester.pumpAndSettle();
    expect(find.text('Diizinkan'), findsOneWidget);

    // Sudah diizinkan: tap tile menawarkan pengaturan sistem, bukan mencabut.
    await tester.tap(find.text('Kamera'));
    await tester.pumpAndSettle();
    expect(find.text('Ubah izin di pengaturan sistem?'), findsOneWidget);
    await tester.tap(find.text('Buka pengaturan'));
    await tester.pumpAndSettle();
    expect(permissions.openedSettings, 1);
    expect(find.text('Diizinkan'), findsOneWidget);
  });

  testWidgets(
    'notifikasi: toggle minta izin, uji menampilkan, ketukan membuka route',
    (tester) async {
      final push = MemoryPushService();
      final permissions = MemoryPermissionService();
      final api = FakeAuthApi(latency: Duration.zero);
      final session = await tester.runAsync(
        () => api.signIn(
          email: FakeAuthApi.demoEmail,
          password: FakeAuthApi.demoPassword,
        ),
      );
      await pumpPhone(
        tester,
        ProviderScope(
          overrides: [
            pushServiceProvider.overrideWithValue(push),
            appDatabaseProvider.overrideWith((ref) {
              final db = AppDatabase.memory();
              ref.onDispose(db.close);
              return db;
            }),
            remoteNoteApiProvider.overrideWithValue(
              FakeNoteApi(latency: Duration.zero),
            ),
            deviceAuthenticatorProvider.overrideWithValue(
              MemoryAuthenticator(available: false),
            ),
            permissionServiceProvider.overrideWithValue(permissions),
            isOnlineProvider.overrideWith((ref) => Stream.value(true)),
            keyValueStoreProvider.overrideWithValue(
              MemoryKeyValueStore({'onboarding_done': true, 'locale': 'id'}),
            ),
            secureStoreProvider.overrideWithValue(
              MemorySecureStore({'auth_token': session!.token}),
            ),
            authApiProvider.overrideWithValue(api),
          ],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Profil').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pengaturan'));
      await tester.pumpAndSettle();

      final notifSwitch = find.descendant(
        of: find.byType(NotificationSettings),
        matching: find.byType(FSwitch),
      );
      await tester.ensureVisible(notifSwitch);
      await tester.tap(notifSwitch);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Lanjutkan')); // dialog penjelasan izin
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Kirim notifikasi uji'));
      await tester.tap(find.text('Kirim notifikasi uji'));
      await tester.pumpAndSettle();
      expect(push.shown, hasLength(1));
      expect(push.shown.single.route, AppRoutes.notes);

      push.open(const PushMessage(route: AppRoutes.notes));
      await tester.pumpAndSettle();
      expect(find.text('Catatan 40'), findsOneWidget);
      // Bongkar tree di dalam test agar timer penutupan stream drift sempat jalan.
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
    },
  );

  testWidgets('banner offline tampil saat tidak ada koneksi', (tester) async {
    final api = FakeAuthApi(latency: Duration.zero);
    final session = await tester.runAsync(
      () => api.signIn(
        email: FakeAuthApi.demoEmail,
        password: FakeAuthApi.demoPassword,
      ),
    );
    await pumpPhone(
      tester,
      buildApp(
        prefs: {'onboarding_done': true},
        secrets: {'auth_token': session!.token},
        authApi: api,
        online: false,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(OfflineBanner), findsOneWidget);
  });

  testWidgets('bahasa mengikuti pilihan user dan bisa diganti', (tester) async {
    await pumpPhone(
      tester,
      buildApp(prefs: {'onboarding_done': true}, locale: 'en'),
    );
    await tester.pumpAndSettle();
    expect(find.text('Sign in'), findsWidgets);
    expect(find.text('Masuk'), findsNothing);

    // Tanpa preferensi: ikuti locale platform test (en_US).
    await pumpPhone(
      tester,
      buildApp(prefs: {'onboarding_done': true}, locale: null),
    );
    await tester.pumpAndSettle();
    expect(find.text('Sign in'), findsWidgets);
  });
}

Future<void> pumpSignedIn(
  WidgetTester tester, {
  FakeNoteApi? notes,
  bool phone = true,
  Map<String, bool>? flags,
  MemoryAuthenticator? authenticator,
  Duration? lockAfter,
}) async {
  if (phone) usePhoneViewport(tester);
  final api = FakeAuthApi(latency: Duration.zero);
  final session = await tester.runAsync(
    () => api.signIn(
      email: FakeAuthApi.demoEmail,
      password: FakeAuthApi.demoPassword,
    ),
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        pushServiceProvider.overrideWithValue(const NoopPushService()),
        isOnlineProvider.overrideWith((ref) => Stream.value(true)),
        keyValueStoreProvider.overrideWithValue(
          MemoryKeyValueStore({'onboarding_done': true, 'locale': 'id'}),
        ),
        secureStoreProvider.overrideWithValue(
          MemorySecureStore({'auth_token': session!.token}),
        ),
        authApiProvider.overrideWithValue(api),
        noteApiProvider.overrideWithValue(
          notes ?? FakeNoteApi(latency: Duration.zero),
        ),
        if (flags != null)
          featureFlagsProvider.overrideWithValue(MemoryFeatureFlags(flags)),
        if (authenticator != null)
          deviceAuthenticatorProvider.overrideWithValue(authenticator),
        if (lockAfter != null)
          appLockTimeoutProvider.overrideWithValue(lockAfter),
      ],
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();
}

void notesTests() {
  testWidgets('daftar catatan memuat halaman kedua saat digulir', (
    tester,
  ) async {
    await pumpSignedIn(tester);
    await tester.tap(find.text('Catatan').last);
    await tester.pumpAndSettle();

    expect(find.text('Catatan 40'), findsOneWidget); // terbaru di atas
    expect(find.text('Catatan 1'), findsNothing); // halaman 2 belum dimuat

    for (var i = 0; i < 6; i++) {
      await tester.drag(find.byType(ListView), const Offset(0, -2000));
      await tester.pumpAndSettle();
    }
    expect(find.text('Catatan 1'), findsOneWidget);
  });

  testWidgets('membuat catatan baru menampilkannya di detail dan daftar', (
    tester,
  ) async {
    await pumpSignedIn(tester);
    await tester.tap(find.text('Catatan').last);
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Catatan baru'));
    await tester.pumpAndSettle();
    expect(find.text('Catatan baru'), findsWidgets);

    await tester.tap(find.widgetWithText(FButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Wajib diisi'), findsWidgets); // validasi

    await enterField(tester, 0, 'Belanja mingguan');
    await enterField(tester, 1, 'Telur, susu, kopi.');
    await tester.tap(find.widgetWithText(FButton, 'Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Belanja mingguan'), findsOneWidget); // halaman detail
    expect(find.text('Telur, susu, kopi.'), findsOneWidget);

    await tester.tap(find.text('Catatan').last); // kembali ke root tab
    await tester.pumpAndSettle();
    expect(find.text('Belanja mingguan'), findsOneWidget); // paling atas
  });

  testWidgets('menghapus catatan dari detail kembali ke daftar', (
    tester,
  ) async {
    await pumpSignedIn(tester);
    await tester.tap(find.text('Catatan').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Catatan 40'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(DeleteNoteButton));
    await tester.tap(find.byType(DeleteNoteButton));
    await tester.pumpAndSettle();
    expect(find.text('Hapus catatan?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FButton, 'Hapus').last);
    await tester.pumpAndSettle();

    expect(find.text('Catatan 40'), findsNothing);
    expect(find.text('Catatan 39'), findsOneWidget);
  });
}

void flagTests() {
  testWidgets('flag notes_create_enabled=false menyembunyikan tombol buat', (
    tester,
  ) async {
    await pumpSignedIn(tester, flags: {'notes_create_enabled': false});
    await tester.tap(find.text('Catatan').last);
    await tester.pumpAndSettle();
    expect(find.text('Catatan 40'), findsOneWidget);
    expect(find.bySemanticsLabel('Catatan baru'), findsNothing);

    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pengaturan'));
    await tester.pumpAndSettle();
    // ListView membangun anak secara lazy; gulir daftar pengaturan ke bawah.
    final settingsList = find.descendant(
      of: find.byType(SettingsPage),
      matching: find.byType(Scrollable),
    );
    await tester.scrollUntilVisible(
      find.text('Feature flags'),
      200,
      scrollable: settingsList.first,
    );
    // Gulir sedikit lagi agar tile tidak tertutup bottom tabs saat ditap.
    await tester.drag(settingsList.first, const Offset(0, -300));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Feature flags'));
    await tester.pumpAndSettle();
    expect(find.byType(FeatureFlagsPage), findsOneWidget);
    expect(find.text('notes_create_enabled'), findsOneWidget);
  });
}

void appLockTests() {
  testWidgets('kunci aplikasi: aktifkan, kembali dari background, buka', (
    tester,
  ) async {
    final auth = MemoryAuthenticator();
    await pumpSignedIn(tester, authenticator: auth, lockAfter: Duration.zero);
    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pengaturan'));
    await tester.pumpAndSettle();

    final settingsList = find.descendant(
      of: find.byType(SettingsPage),
      matching: find.byType(Scrollable),
    );
    await tester.scrollUntilVisible(
      find.byType(AppLockSwitch),
      200,
      scrollable: settingsList.first,
    );
    await tester.drag(settingsList.first, const Offset(0, -200));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(AppLockSwitch),
        matching: find.byType(FSwitch),
      ),
    );
    await tester.pumpAndSettle();
    expect(auth.attempts, 1); // verifikasi saat mengaktifkan
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(find.byType(LockPage), findsOneWidget);

    auth.result = false;
    await tester.tap(find.widgetWithText(FButton, 'Buka'));
    await tester.pumpAndSettle();
    expect(find.text('Verifikasi gagal. Coba lagi.'), findsOneWidget);

    auth.result = true;
    await tester.tap(find.widgetWithText(FButton, 'Buka'));
    await tester.pumpAndSettle();
    expect(find.byType(LockPage), findsNothing);
    expect(find.byType(SettingsPage), findsOneWidget);
  });

  testWidgets('tanpa biometrik toggle kunci nonaktif', (tester) async {
    await pumpSignedIn(
      tester,
      authenticator: MemoryAuthenticator(available: false),
    );
    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pengaturan'));
    await tester.pumpAndSettle();
    final settingsList = find.descendant(
      of: find.byType(SettingsPage),
      matching: find.byType(Scrollable),
    );
    await tester.scrollUntilVisible(
      find.byType(AppLockSwitch),
      200,
      scrollable: settingsList.first,
    );
    expect(
      find.text('Perangkat ini belum punya biometrik atau PIN.'),
      findsOneWidget,
    );
  });
}

void profileTests() {
  testWidgets('ubah profil memperbarui sapaan di beranda', (tester) async {
    await pumpSignedIn(tester);
    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ubah profil'));
    await tester.pumpAndSettle();

    await enterField(tester, 0, 'Demo Baru');
    await tester.tap(find.widgetWithText(FButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Demo Baru'), findsWidgets); // kartu profil

    await tester.tap(find.text('Beranda').last);
    await tester.pumpAndSettle();
    expect(find.text('Halo, Demo Baru'), findsOneWidget);
  });

  testWidgets('ganti password menolak password lama yang salah', (
    tester,
  ) async {
    await pumpSignedIn(tester);
    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ganti password'));
    await tester.pumpAndSettle();

    await enterField(tester, 0, 'salah');
    await enterField(tester, 1, 'baru1234');
    await enterField(tester, 2, 'baru1234');
    await tester.tap(find.widgetWithText(FButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Password saat ini salah.'), findsOneWidget);

    await enterField(tester, 0, FakeAuthApi.demoPassword);
    await tester.tap(find.widgetWithText(FButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Password diganti'), findsOneWidget); // toast
    expect(
      find.text('Ganti password'),
      findsOneWidget,
    ); // kembali ke tile profil
  });
}

void responsiveTests() {
  testWidgets('layar lebar memakai sidebar, bukan bottom tabs', (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pumpSignedIn(tester, phone: false);
    expect(find.byType(FSidebar), findsOneWidget);
    expect(find.byType(FBottomNavigationBar), findsNothing);

    await tester.tap(find.widgetWithText(FSidebarItem, 'Catatan'));
    await tester.pumpAndSettle();
    expect(find.text('Catatan 40'), findsOneWidget);
  });
}

void notificationPermissionTests() {
  testWidgets('preferensi notifikasi mati saat app mulai tanpa izin sistem', (
    tester,
  ) async {
    final push = MemoryPushService();
    final permissions = MemoryPermissionService(
      initial: {AppPermission.notifications: PermissionResult.denied},
    );
    final api = FakeAuthApi(latency: Duration.zero);
    final session = await tester.runAsync(
      () => api.signIn(
        email: FakeAuthApi.demoEmail,
        password: FakeAuthApi.demoPassword,
      ),
    );
    final prefs = MemoryKeyValueStore({
      'onboarding_done': true,
      'locale': 'id',
      notificationsEnabledKey: true, // tersimpan on, tapi izin sudah dicabut
    });
    await pumpPhone(
      tester,
      ProviderScope(
        overrides: [
          pushServiceProvider.overrideWithValue(push),
          permissionServiceProvider.overrideWithValue(permissions),
          deviceAuthenticatorProvider.overrideWithValue(
            MemoryAuthenticator(available: false),
          ),
          isOnlineProvider.overrideWith((ref) => Stream.value(true)),
          keyValueStoreProvider.overrideWithValue(prefs),
          secureStoreProvider.overrideWithValue(
            MemorySecureStore({'auth_token': session!.token}),
          ),
          authApiProvider.overrideWithValue(api),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
    expect(push.enabled, isFalse);
    expect(await prefs.getBool(notificationsEnabledKey), isFalse);
  });
}
