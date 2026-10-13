// Integration test: berjalan di device nyata (Waydroid) lewat `just itest`.
// Memakai storage in-memory dan FakeAuthApi agar tidak menyentuh data user.
import 'package:droid/app/index.dart';
import 'package:droid/entities/user/index.dart';
import 'package:droid/features/sign_out/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('sign in demo → home → profil → keluar', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          keyValueStoreProvider.overrideWithValue(
            MemoryKeyValueStore({'onboarding_done': true, 'locale': 'id'}),
          ),
          secureStoreProvider.overrideWithValue(MemorySecureStore()),
          authApiProvider.overrideWithValue(
            FakeAuthApi(latency: const Duration(milliseconds: 100)),
          ),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.widgetWithText(FButton, 'Masuk'), findsOneWidget);

    await tester.enterText(
      find.byType(EditableText).at(0),
      FakeAuthApi.demoEmail,
    );
    await tester.enterText(
      find.byType(EditableText).at(1),
      FakeAuthApi.demoPassword,
    );
    await tester.tap(find.widgetWithText(FButton, 'Masuk'));
    await tester.pumpAndSettle();
    expect(find.text('Halo, Demo'), findsOneWidget);

    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(SignOutButton));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FButton, 'Keluar').last);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(FButton, 'Masuk'), findsOneWidget);
  });
}
