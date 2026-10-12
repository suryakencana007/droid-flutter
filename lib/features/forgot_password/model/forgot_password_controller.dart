import 'package:droid/entities/user/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State `true` berarti permintaan reset sudah terkirim.
class ForgotPasswordController extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async => false;

  Future<void> submit(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authApiProvider).requestPasswordReset(email);
      return true;
    });
  }

  void reset() => state = const AsyncData(false);
}

final forgotPasswordControllerProvider =
    AsyncNotifierProvider<ForgotPasswordController, bool>(
  ForgotPasswordController.new,
);
