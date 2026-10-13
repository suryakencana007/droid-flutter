import 'package:droid/shared/lib/permissions/permission_service.dart';
import 'package:flutter/widgets.dart';

import '../l10n/index.dart';
import 'confirm_dialog.dart';

/// Alur minta izin yang sopan: jelaskan dulu, minta, dan bila ditolak permanen
/// tawarkan membuka pengaturan sistem. Mengembalikan hasil akhirnya.
Future<PermissionResult> ensurePermission(
  BuildContext context, {
  required PermissionService service,
  required AppPermission permission,
  required String title,
  required String rationale,
}) async {
  final current = await service.status(permission);
  if (current == PermissionResult.granted) return current!;
  if (!context.mounted) return current ?? PermissionResult.denied;
  final l10n = context.l10n;

  if (current == PermissionResult.permanentlyDenied) {
    return _offerSettings(context, service, l10n);
  }

  final proceed = await showConfirmDialog(
    context,
    title: title,
    message: rationale,
    confirmLabel: l10n.permissionContinue,
    cancelLabel: l10n.cancel,
  );
  if (!proceed) return PermissionResult.denied;

  final result = await service.request(permission);
  if (result == PermissionResult.permanentlyDenied && context.mounted) {
    return _offerSettings(context, service, l10n);
  }
  return result;
}

Future<PermissionResult> _offerSettings(
  BuildContext context,
  PermissionService service,
  AppLocalizations l10n,
) async {
  final open = await showConfirmDialog(
    context,
    title: l10n.permissionDeniedTitle,
    message: l10n.permissionDeniedBody,
    confirmLabel: l10n.openSettings,
    cancelLabel: l10n.cancel,
  );
  if (open) await service.openSettings();
  return PermissionResult.permanentlyDenied;
}
