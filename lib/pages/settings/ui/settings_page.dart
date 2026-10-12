import 'package:droid/features/sign_out/index.dart';
import 'package:droid/features/toggle_theme/index.dart';
import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const ThemeModeSelector(),
          const Gap(AppSpacing.lg),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final info = snapshot.data;
              final version = info == null
                  ? '...'
                  : '${info.version} (${info.buildNumber})';
              return FTileGroup(
                label: const Text('Tentang'),
                children: [
                  FTile(
                    prefix: const Icon(FLucideIcons.info),
                    title: const Text('Aplikasi'),
                    details: const Text(AppInfo.name),
                  ),
                  FTile(
                    prefix: const Icon(FLucideIcons.tag),
                    title: const Text('Versi'),
                    details: Text(version),
                  ),
                ],
              );
            },
          ),
          const Gap(AppSpacing.lg),
          const SignOutButton(),
        ],
      ),
    );
  }
}
