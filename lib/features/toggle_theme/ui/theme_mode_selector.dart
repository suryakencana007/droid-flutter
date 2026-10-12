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
      label: const Text('Tema'),
      description: const Text('Berlaku di seluruh aplikasi dan diingat.'),
      children: const [
        FSelectTile(
          title: Text('Ikuti sistem'),
          subtitle: Text('Mengikuti pengaturan perangkat'),
          value: ThemeMode.system,
        ),
        FSelectTile(title: Text('Terang'), value: ThemeMode.light),
        FSelectTile(title: Text('Gelap'), value: ThemeMode.dark),
      ],
    );
  }
}
