import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  /// Balik tema berdasarkan brightness yang sedang efektif di layar.
  ///
  /// Dari [ThemeMode.system] kita tidak tahu apakah layar gelap atau terang,
  /// jadi caller mengirim [isCurrentlyDark] hasil resolusi di UI.
  void toggle({required bool isCurrentlyDark}) {
    state = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
  }

  void reset() => state = ThemeMode.system;
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
