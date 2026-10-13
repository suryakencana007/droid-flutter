import 'package:droid/features/manage_notifications/index.dart';
import 'package:droid/features/manage_permissions/index.dart';
import 'package:droid/features/select_locale/index.dart';
import 'package:droid/features/sign_out/index.dart';
import 'package:droid/features/toggle_theme/index.dart';
import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const ThemeModeSelector(),
          const Gap(AppSpacing.lg),
          const LocaleSelector(),
          const Gap(AppSpacing.lg),
          const NotificationSettings(),
          const Gap(AppSpacing.lg),
          const PermissionTiles(),
          const Gap(AppSpacing.lg),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final info = snapshot.data;
              final version = info == null
                  ? '...'
                  : '${info.version} (${info.buildNumber})';
              return FTileGroup(
                label: Text(l10n.aboutLabel),
                children: [
                  FTile(
                    prefix: const Icon(FLucideIcons.info),
                    title: Text(l10n.appLabel),
                    details: const Text(AppInfo.name),
                  ),
                  FTile(
                    prefix: const Icon(FLucideIcons.tag),
                    title: Text(l10n.versionLabel),
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
