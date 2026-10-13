import 'package:droid/shared/lib/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Status tiap izin; dimuat ulang setelah user merespons dialog sistem.
class PermissionStatusNotifier
    extends AsyncNotifier<Map<AppPermission, PermissionResult?>> {
  @override
  Future<Map<AppPermission, PermissionResult?>> build() async {
    final service = ref.read(permissionServiceProvider);
    return {for (final p in AppPermission.values) p: await service.status(p)};
  }

  Future<void> refresh() async => state = AsyncData(await build());
}

final permissionStatusProvider =
    AsyncNotifierProvider<
      PermissionStatusNotifier,
      Map<AppPermission, PermissionResult?>
    >(PermissionStatusNotifier.new);
