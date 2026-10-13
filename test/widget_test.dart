import 'package:droid/app/index.dart';
import 'package:droid/entities/user/index.dart';
import 'package:droid/features/sign_out/index.dart';
import 'package:droid/features/toggle_theme/index.dart';
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
}) {
  return ProviderScope(
    overrides: [
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

Future<void> enterField(WidgetTester tester, int index, String text) async {
  await tester.enterText(find.byType(EditableText).at(index), text);
  await tester.pump();
}

void main() {
  testWidgets('alur pertama: onboarding → sign in → home → sign out',
      (tester) async {
    await tester.pumpWidget(buildApp());
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

  testWidgets('token tersimpan langsung ke home tanpa onboarding',
      (tester) async {
    final api = FakeAuthApi(latency: Duration.zero);
    // runAsync: FakeAuthApi memakai Future.delayed yang tidak jalan di zona
    // fake-async test sebelum ada pump.
    final session = await tester.runAsync(
      () => api.signIn(
        email: FakeAuthApi.demoEmail,
        password: FakeAuthApi.demoPassword,
      ),
    );

    await tester.pumpWidget(buildApp(
      prefs: {'onboarding_done': true},
      secrets: {'auth_token': session!.token},
      authApi: api,
    ));
    await tester.pumpAndSettle();

    expect(find.text('Halo, Demo'), findsOneWidget);
  });

  testWidgets('sign up membuat akun dan masuk', (tester) async {
    await tester.pumpWidget(buildApp(prefs: {'onboarding_done': true}));
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
    final prefs = MemoryKeyValueStore({'onboarding_done': true, 'locale': 'id'});

    await tester.pumpWidget(ProviderScope(
      overrides: [
        keyValueStoreProvider.overrideWithValue(prefs),
        secureStoreProvider.overrideWithValue(
          MemorySecureStore({'auth_token': session!.token}),
        ),
        authApiProvider.overrideWithValue(api),
      ],
      child: const App(),
    ));
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

  testWidgets('bahasa mengikuti pilihan user dan bisa diganti', (tester) async {
    await tester.pumpWidget(buildApp(prefs: {'onboarding_done': true}, locale: 'en'));
    await tester.pumpAndSettle();
    expect(find.text('Sign in'), findsWidgets);
    expect(find.text('Masuk'), findsNothing);

    // Tanpa preferensi: ikuti locale platform test (en_US).
    await tester.pumpWidget(buildApp(prefs: {'onboarding_done': true}, locale: null));
    await tester.pumpAndSettle();
    expect(find.text('Sign in'), findsWidgets);
  });
}
