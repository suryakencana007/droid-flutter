import 'package:droid/entities/user/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignOutController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final tokens = ref.read(tokenStoreProvider);
      final token = await tokens.read();
      if (token != null) {
        try {
          await ref.read(authApiProvider).signOut(token);
        } on Exception {
          // Sesi lokal tetap dihapus walau server tidak bisa dihubungi.
        }
      }
      await tokens.clear();
      ref.read(currentUserProvider.notifier).clear();
    });
  }
}

final signOutControllerProvider =
    AsyncNotifierProvider<SignOutController, void>(SignOutController.new);
