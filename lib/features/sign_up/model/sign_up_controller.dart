import 'package:droid/entities/user/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> submit({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await ref
          .read(authApiProvider)
          .signUp(name: name, email: email, password: password);
      await ref.read(tokenStoreProvider).write(result.token);
      ref.read(currentUserProvider.notifier).set(result.user);
    });
    return !state.hasError;
  }
}

final signUpControllerProvider =
    AsyncNotifierProvider<SignUpController, void>(SignUpController.new);
