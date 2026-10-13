import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../model/theme_mode_provider.dart';

/// Pilihan tema (sistem / terang / gelap) sebagai grup tile radio.
class ThemeModeSelector extends ConsumerWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider).value ?? ThemeMode.system;
    final l10n = context.l10n;

    return FSelectTileGroup<ThemeMode>(
      control: FMultiValueControl.lifted(
        value: {mode},
        onChange: (values) {
          // Perilaku radio: ambil nilai baru selain yang sedang aktif.
          final next = values.difference({mode});
          if (next.isNotEmpty) {
            ref.read(themeModeProvider.notifier).set(next.first);
          }
        },
      ),
      label: Text(l10n.themeLabel),
      description: Text(l10n.themeDescription),
      children: [
        FSelectTile(
          title: Text(l10n.themeSystem),
          subtitle: Text(l10n.themeSystemSub),
          value: ThemeMode.system,
        ),
        FSelectTile(title: Text(l10n.themeLight), value: ThemeMode.light),
        FSelectTile(title: Text(l10n.themeDark), value: ThemeMode.dark),
      ],
    );
  }
}
