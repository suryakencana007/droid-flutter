import 'package:droid/shared/ui/index.dart';
import 'package:droid/widgets/app_bar/index.dart';
import 'package:material_ui/material_ui.dart';

/// Placeholder tab kedua. Ganti dengan konten aplikasimu.
class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    void open(String name) => showFToast(
          context: context,
          title: Text(name),
          description: const Text('Contoh item. Ganti dengan fitur nyata.'),
        );

    return Scaffold(
      appBar: const DroidAppBar(title: 'Jelajah'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          FTileGroup(
            label: const Text('Contoh daftar'),
            children: [
              FTile(
                prefix: const Icon(FLucideIcons.layers),
                title: const Text('Feature-Sliced Design'),
                subtitle: const Text('Aturan layer dan slice'),
                suffix: const Icon(FLucideIcons.chevronRight),
                onPress: () => open('Feature-Sliced Design'),
              ),
              FTile(
                prefix: const Icon(FLucideIcons.palette),
                title: const Text('UI kit forui'),
                subtitle: const Text('Komponen dan tema'),
                suffix: const Icon(FLucideIcons.chevronRight),
                onPress: () => open('UI kit forui'),
              ),
              FTile(
                prefix: const Icon(FLucideIcons.smartphone),
                title: const Text('Waydroid'),
                subtitle: const Text('Uji di Android tanpa emulator'),
                suffix: const Icon(FLucideIcons.chevronRight),
                onPress: () => open('Waydroid'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
