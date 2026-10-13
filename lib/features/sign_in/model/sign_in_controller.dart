import 'package:droid/entities/user/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Mengembalikan `true` bila berhasil. Error tersimpan di [state].
  Future<bool> submit({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await ref
          .read(authApiProvider)
          .signIn(email: email, password: password);
      await ref.read(tokenStoreProvider).write(result.token);
      ref.read(currentUserProvider.notifier).set(result.user);
      await ref.read(analyticsProvider).logEvent('sign_in');
    });
    return !state.hasError;
  }
}

final signInControllerProvider = AsyncNotifierProvider<SignInController, void>(
  SignInController.new,
);
