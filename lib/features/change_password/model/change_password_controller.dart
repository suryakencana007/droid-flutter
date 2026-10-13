import 'package:droid/entities/user/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePasswordController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> submit({required String current, required String next}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final token = await ref.read(tokenStoreProvider).read();
      if (token == null) {
        throw const AuthException('unauthorized', 'no session');
      }
      await ref
          .read(authApiProvider)
          .changePassword(token, current: current, next: next);
      await ref.read(analyticsProvider).logEvent('password_change');
    });
    return !state.hasError;
  }
}

final changePasswordControllerProvider =
    AsyncNotifierProvider<ChangePasswordController, void>(
      ChangePasswordController.new,
    );
