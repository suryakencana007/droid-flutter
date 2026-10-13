import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:droid/widgets/app_bar/index.dart';
import 'package:material_ui/material_ui.dart';

/// Placeholder tab kedua. Ganti dengan konten aplikasimu.
class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    void open(String name) => showFToast(
          context: context,
          title: Text(name),
          description: Text(l10n.exploreItemBody),
        );

    return Scaffold(
      appBar: DroidAppBar(title: l10n.tabExplore),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          FTileGroup(
            label: Text(l10n.exploreListLabel),
            children: [
              FTile(
                prefix: const Icon(FLucideIcons.layers),
                title: Text(l10n.exploreFsd),
                subtitle: Text(l10n.exploreFsdSub),
                suffix: const Icon(FLucideIcons.chevronRight),
                onPress: () => open(l10n.exploreFsd),
              ),
              FTile(
                prefix: const Icon(FLucideIcons.palette),
                title: Text(l10n.exploreUiKit),
                subtitle: Text(l10n.exploreUiKitSub),
                suffix: const Icon(FLucideIcons.chevronRight),
                onPress: () => open(l10n.exploreUiKit),
              ),
              FTile(
                prefix: const Icon(FLucideIcons.smartphone),
                title: Text(l10n.exploreWaydroid),
                subtitle: Text(l10n.exploreWaydroidSub),
                suffix: const Icon(FLucideIcons.chevronRight),
                onPress: () => open(l10n.exploreWaydroid),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
