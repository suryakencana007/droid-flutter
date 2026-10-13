import 'package:droid/shared/lib/index.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLockState {
  const AppLockState({
    required this.enabled,
    required this.locked,
    required this.available,
  });

  final bool enabled;

  /// `true` saat layar kunci harus ditampilkan.
  final bool locked;

  /// Perangkat punya biometrik atau PIN.
  final bool available;

  AppLockState copyWith({bool? enabled, bool? locked, bool? available}) =>
      AppLockState(
        enabled: enabled ?? this.enabled,
        locked: locked ?? this.locked,
        available: available ?? this.available,
      );
}

/// Lama app boleh di background sebelum terkunci lagi.
final appLockTimeoutProvider = Provider<Duration>(
  (_) => const Duration(seconds: 30),
);

/// Kunci aplikasi: aktif/nonaktif persisten, status terkunci saat runtime,
/// dan pemantauan siklus hidup app untuk mengunci setelah background.
class AppLockNotifier extends AsyncNotifier<AppLockState>
    with WidgetsBindingObserver {
  static const _key = 'app_lock_enabled';

  DateTime? _hiddenAt;

  @override
  Future<AppLockState> build() async {
    final enabled =
        await ref.read(keyValueStoreProvider).getBool(_key) ?? false;
    final available = await ref.read(deviceAuthenticatorProvider).isAvailable();

    final binding = WidgetsBinding.instance..addObserver(this);
    ref.onDispose(() => binding.removeObserver(this));

    return AppLockState(
      enabled: enabled,
      locked: enabled, // app baru dibuka: minta verifikasi dulu
      available: available,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.hidden || AppLifecycleState.paused:
        _hiddenAt ??= DateTime.now();
      case AppLifecycleState.resumed:
        _onShow();
      case _:
    }
  }

  void _onShow() {
    final current = state.value;
    final hiddenAt = _hiddenAt;
    _hiddenAt = null;
    if (current == null || !current.enabled || hiddenAt == null) return;
    final away = DateTime.now().difference(hiddenAt);
    if (away >= ref.read(appLockTimeoutProvider)) {
      state = AsyncData(current.copyWith(locked: true));
    }
  }

  /// Mengaktifkan butuh verifikasi dulu agar user tidak terkunci dari app-nya
  /// sendiri. Mengembalikan `true` bila perubahan diterapkan.
  Future<bool> setEnabled(bool enabled, {required String reason}) async {
    final current = state.value;
    if (current == null) return false;
    if (enabled) {
      final ok = await ref
          .read(deviceAuthenticatorProvider)
          .authenticate(reason);
      if (!ok) return false;
    }
    await ref.read(keyValueStoreProvider).setBool(_key, enabled);
    state = AsyncData(current.copyWith(enabled: enabled, locked: false));
    return true;
  }

  Future<bool> unlock({required String reason}) async {
    final current = state.value;
    if (current == null) return false;
    final ok = await ref.read(deviceAuthenticatorProvider).authenticate(reason);
    if (ok) state = AsyncData(current.copyWith(locked: false));
    return ok;
  }
}

final appLockProvider = AsyncNotifierProvider<AppLockNotifier, AppLockState>(
  AppLockNotifier.new,
);
