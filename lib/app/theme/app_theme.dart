import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _seed = Color(0xFF3F51B5);

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(seedColor: _seed, brightness: brightness);
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
      ),
      cardTheme: const CardThemeData(margin: EdgeInsets.zero),
    );
  }
}
