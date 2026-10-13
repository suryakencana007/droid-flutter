import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../model/notifications_enabled_provider.dart';

/// Toggle notifikasi (minta izin saat diaktifkan) dan tombol notifikasi uji.
class NotificationSettings extends ConsumerWidget {
  const NotificationSettings({super.key});

  Future<void> _toggle(BuildContext context, WidgetRef ref, bool value) async {
    final l10n = context.l10n;
    if (!value) {
      await ref.read(notificationsEnabledProvider.notifier).set(false);
      return;
    }
    final result = await ensurePermission(
      context,
      service: ref.read(permissionServiceProvider),
      permission: AppPermission.notifications,
      title: l10n.permissionNotifications,
      rationale: l10n.permissionNotificationsBody,
    );
    await ref
        .read(notificationsEnabledProvider.notifier)
        .set(result == PermissionResult.granted);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final enabled = ref.watch(notificationsEnabledProvider).value ?? false;

    return FTileGroup(
      label: Text(l10n.notificationsLabel),
      children: [
        FTile(
          prefix: const Icon(FLucideIcons.bellRing),
          title: Text(l10n.notificationsToggle),
          subtitle: Text(l10n.notificationsToggleBody),
          suffix: FSwitch(
            value: enabled,
            onChange: (value) => _toggle(context, ref, value),
          ),
        ),
        FTile(
          prefix: const Icon(FLucideIcons.send),
          title: Text(l10n.sendTestNotification),
          enabled: enabled,
          suffix: const Icon(FLucideIcons.chevronRight),
          onPress: () => ref
              .read(pushServiceProvider)
              .showLocal(
                PushMessage(
                  title: l10n.testNotificationTitle(AppInfo.name),
                  body: l10n.testNotificationBody,
                  route: AppRoutes.notes,
                ),
              ),
        ),
      ],
    );
  }
}
