import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'permission_service.dart';

/// Status tiap izin. Dimuat ulang setelah user merespons dialog sistem dan
/// setiap app kembali ke depan (user bisa mengubah izin di pengaturan sistem).
class PermissionStatusNotifier
    extends AsyncNotifier<Map<AppPermission, PermissionResult?>>
    with WidgetsBindingObserver {
  @override
  Future<Map<AppPermission, PermissionResult?>> build() async {
    final binding = WidgetsBinding.instance..addObserver(this);
    ref.onDispose(() => binding.removeObserver(this));
    return _load();
  }

  Future<Map<AppPermission, PermissionResult?>> _load() async {
    final service = ref.read(permissionServiceProvider);
    return {for (final p in AppPermission.values) p: await service.status(p)};
  }

  Future<void> refresh() async => state = AsyncData(await _load());

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) refresh();
  }
}

final permissionStatusProvider =
    AsyncNotifierProvider<
      PermissionStatusNotifier,
      Map<AppPermission, PermissionResult?>
    >(PermissionStatusNotifier.new);

/// Status satu izin; `true` hanya bila diizinkan.
final permissionGrantedProvider = Provider.family<bool, AppPermission>(
  (ref, permission) =>
      ref.watch(permissionStatusProvider).value?[permission] ==
      PermissionResult.granted,
);
