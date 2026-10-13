import 'package:droid/entities/user/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfileController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> submit({required String name}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final token = await ref.read(tokenStoreProvider).read();
      if (token == null) {
        throw const AuthException('unauthorized', 'no session');
      }
      final user = await ref
          .read(authApiProvider)
          .updateProfile(token, name: name);
      ref.read(currentUserProvider.notifier).set(user);
      await ref.read(analyticsProvider).logEvent('profile_update');
    });
    return !state.hasError;
  }
}

final editProfileControllerProvider =
    AsyncNotifierProvider<EditProfileController, void>(
      EditProfileController.new,
    );
