import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../model/app_lock_provider.dart';

/// Toggle kunci aplikasi untuk halaman pengaturan.
class AppLockSwitch extends ConsumerWidget {
  const AppLockSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final lock = ref.watch(appLockProvider).value;
    final available = lock?.available ?? false;

    return FTileGroup(
      label: Text(l10n.appLockLabel),
      children: [
        FTile(
          prefix: const Icon(FLucideIcons.fingerprint),
          title: Text(l10n.appLockToggle),
          subtitle: Text(
            available ? l10n.appLockToggleBody : l10n.appLockUnavailable,
          ),
          enabled: available,
          suffix: FSwitch(
            value: lock?.enabled ?? false,
            onChange: available
                ? (value) => ref
                      .read(appLockProvider.notifier)
                      .setEnabled(
                        value,
                        reason: l10n.unlockReason(AppInfo.name),
                      )
                : null,
          ),
        ),
      ],
    );
  }
}
