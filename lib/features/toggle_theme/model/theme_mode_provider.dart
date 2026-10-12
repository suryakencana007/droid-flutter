import 'package:droid/shared/lib/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Mode tema pilihan user, disimpan di [KeyValueStore].
class ThemeModeNotifier extends AsyncNotifier<ThemeMode> {
  static const _key = 'theme_mode';

  @override
  Future<ThemeMode> build() async {
    final raw = await ref.read(keyValueStoreProvider).getString(_key);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == raw,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> set(ThemeMode mode) async {
    state = AsyncData(mode);
    await ref.read(keyValueStoreProvider).setString(_key, mode.name);
  }

  /// Balik tema berdasarkan brightness yang sedang efektif di layar.
  ///
  /// Dari [ThemeMode.system] kita tidak tahu apakah layar gelap atau terang,
  /// jadi caller mengirim [isCurrentlyDark] hasil resolusi di UI.
  Future<void> toggle({required bool isCurrentlyDark}) =>
      set(isCurrentlyDark ? ThemeMode.light : ThemeMode.dark);
}

final themeModeProvider =
    AsyncNotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
