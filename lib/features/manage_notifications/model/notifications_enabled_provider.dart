import 'package:droid/shared/lib/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Preferensi "terima notifikasi". Mengaktifkan butuh izin sistem; pemanggil
/// (UI) meminta izin lewat `ensurePermission` lalu memanggil [set].
class NotificationsEnabledNotifier extends AsyncNotifier<bool> {
  static const _key = notificationsEnabledKey;

  @override
  Future<bool> build() async =>
      await ref.read(keyValueStoreProvider).getBool(_key) ?? false;

  Future<void> set(bool enabled) async {
    state = AsyncData(enabled);
    await ref.read(keyValueStoreProvider).setBool(_key, enabled);
  }
}

final notificationsEnabledProvider =
    AsyncNotifierProvider<NotificationsEnabledNotifier, bool>(
      NotificationsEnabledNotifier.new,
    );
