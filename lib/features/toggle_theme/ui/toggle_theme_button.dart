import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/theme_mode_provider.dart';

class ToggleThemeButton extends ConsumerWidget {
  const ToggleThemeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final isDark = switch (mode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system =>
        MediaQuery.platformBrightnessOf(context) == Brightness.dark,
    };

    return IconButton(
      tooltip: isDark ? 'Mode terang' : 'Mode gelap',
      icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
      onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
    );
  }
}
