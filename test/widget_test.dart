import 'package:droid/app/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomePage tampil dan toggle tema bekerja', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();

    expect(find.text('Feature-Sliced Design bootstrap'), findsOneWidget);
    expect(find.text('Surya'), findsOneWidget);

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.system);

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    final toggled = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(toggled.themeMode, ThemeMode.dark);

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    final toggledBack = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(toggledBack.themeMode, ThemeMode.light);
  });

  testWidgets('dari mode system, toggle membalik brightness platform',
      (tester) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.light);
  });
}
