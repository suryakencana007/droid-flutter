import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../model/permission_status_provider.dart';

/// Daftar izin dengan status dan tombol minta; ditaruh di halaman pengaturan.
class PermissionTiles extends ConsumerWidget {
  const PermissionTiles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final statuses = ref.watch(permissionStatusProvider).value ?? const {};

    String label(PermissionResult? r) => switch (r) {
      PermissionResult.granted => l10n.permissionGranted,
      PermissionResult.denied => l10n.permissionDenied,
      PermissionResult.permanentlyDenied => l10n.permissionPermanentlyDenied,
      null => l10n.permissionUnknown,
    };

    Future<void> ask(AppPermission p, String title, String rationale) async {
      await ensurePermission(
        context,
        service: ref.read(permissionServiceProvider),
        permission: p,
        title: title,
        rationale: rationale,
      );
      await ref.read(permissionStatusProvider.notifier).refresh();
    }

    final entries = [
      (
        AppPermission.notifications,
        FLucideIcons.bell,
        l10n.permissionNotifications,
        l10n.permissionNotificationsBody,
      ),
      (
        AppPermission.camera,
        FLucideIcons.camera,
        l10n.permissionCamera,
        l10n.permissionCameraBody,
      ),
      (
        AppPermission.location,
        FLucideIcons.mapPin,
        l10n.permissionLocation,
        l10n.permissionLocationBody,
      ),
    ];

    return FTileGroup(
      label: Text(l10n.permissionsLabel),
      description: Text(l10n.permissionsDescription),
      children: [
        for (final (permission, icon, title, body) in entries)
          FTile(
            prefix: Icon(icon),
            title: Text(title),
            details: Text(label(statuses[permission])),
            suffix: const Icon(FLucideIcons.chevronRight),
            onPress: () => ask(permission, title, body),
          ),
      ],
    );
  }
}
