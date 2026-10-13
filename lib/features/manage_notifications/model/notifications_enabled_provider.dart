import 'package:droid/shared/lib/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Preferensi "terima notifikasi". Mengaktifkan butuh izin sistem; pemanggil
/// (UI) meminta izin lewat `ensurePermission` lalu memanggil [set].
///
/// Bila izin sistem ternyata tidak ada (dicabut lewat pengaturan sistem, yang
/// di Android juga mematikan proses app), preferensi ikut dimatikan saat app
/// mulai atau kembali ke depan, agar toggle dan pendaftaran di server jujur.
class NotificationsEnabledNotifier extends AsyncNotifier<bool> {
  static const _key = notificationsEnabledKey;

  @override
  Future<bool> build() async {
    ref.listen(permissionStatusProvider, (_, next) {
      final status = next.value?[AppPermission.notifications];
      // null = belum diketahui (masih memuat); jangan mengambil keputusan.
      if (status != null &&
          status != PermissionResult.granted &&
          state.value == true) {
        set(false);
      }
    });

    final enabled =
        await ref.read(keyValueStoreProvider).getBool(_key) ?? false;
    if (!enabled) return false;
    final status = (await ref.read(
      permissionStatusProvider.future,
    ))[AppPermission.notifications];
    if (status != null && status != PermissionResult.granted) {
      await ref.read(keyValueStoreProvider).setBool(_key, false);
      return false;
    }
    return true;
  }

  Future<void> set(bool enabled) async {
    state = AsyncData(enabled);
    await ref.read(keyValueStoreProvider).setBool(_key, enabled);
  }
}

final notificationsEnabledProvider =
    AsyncNotifierProvider<NotificationsEnabledNotifier, bool>(
      NotificationsEnabledNotifier.new,
    );
