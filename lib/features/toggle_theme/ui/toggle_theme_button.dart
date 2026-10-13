import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../model/theme_mode_provider.dart';

class ToggleThemeButton extends ConsumerWidget {
  const ToggleThemeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider).value ?? ThemeMode.system;
    final isDark = switch (mode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system =>
        MediaQuery.platformBrightnessOf(context) == Brightness.dark,
    };

    return FButton.icon(
      variant: FButtonVariant.ghost,
      semanticsLabel: isDark ? context.l10n.lightMode : context.l10n.darkMode,
      onPress: () =>
          ref.read(themeModeProvider.notifier).toggle(isCurrentlyDark: isDark),
      child: Icon(isDark ? FLucideIcons.sun : FLucideIcons.moon),
    );
  }
}
