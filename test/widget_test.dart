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
  });
}
