import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

/// Izin yang dipakai app. Tambahkan di sini (dan di [HandlerPermissionService])
/// bila fitur baru membutuhkan izin lain; manifest/Info.plist juga perlu entri.
enum AppPermission { notifications, camera, location }

enum PermissionResult { granted, denied, permanentlyDenied }

abstract interface class PermissionService {
  Future<PermissionResult?> status(AppPermission permission);
  Future<PermissionResult> request(AppPermission permission);
  Future<bool> openSettings();
}

/// Implementasi di atas `permission_handler`.
class HandlerPermissionService implements PermissionService {
  const HandlerPermissionService();

  static ph.Permission _map(AppPermission p) => switch (p) {
    AppPermission.notifications => ph.Permission.notification,
    AppPermission.camera => ph.Permission.camera,
    AppPermission.location => ph.Permission.locationWhenInUse,
  };

  static PermissionResult? _result(ph.PermissionStatus s) => switch (s) {
    ph.PermissionStatus.granted ||
    ph.PermissionStatus.limited ||
    ph.PermissionStatus.provisional => PermissionResult.granted,
    ph.PermissionStatus.permanentlyDenied => PermissionResult.permanentlyDenied,
    ph.PermissionStatus.denied ||
    ph.PermissionStatus.restricted => PermissionResult.denied,
  };

  @override
  Future<PermissionResult?> status(AppPermission permission) async =>
      _result(await _map(permission).status);

  @override
  Future<PermissionResult> request(AppPermission permission) async =>
      _result(await _map(permission).request()) ?? PermissionResult.denied;

  @override
  Future<bool> openSettings() => ph.openAppSettings();
}

/// Untuk test: hasil request ditentukan lewat [answers].
class MemoryPermissionService implements PermissionService {
  MemoryPermissionService({
    Map<AppPermission, PermissionResult>? initial,
    this.answers = const {},
  }) : _status = {...?initial};

  final Map<AppPermission, PermissionResult> _status;
  final Map<AppPermission, PermissionResult> answers;
  var openedSettings = 0;

  @override
  Future<PermissionResult?> status(AppPermission permission) async =>
      _status[permission];

  @override
  Future<PermissionResult> request(AppPermission permission) async =>
      _status[permission] = answers[permission] ?? PermissionResult.granted;

  @override
  Future<bool> openSettings() async {
    openedSettings++;
    return true;
  }

  /// Simulasi user mengubah izin lewat pengaturan sistem.
  void setStatus(AppPermission permission, PermissionResult result) =>
      _status[permission] = result;
}

final permissionServiceProvider = Provider<PermissionService>(
  (_) => const HandlerPermissionService(),
);
