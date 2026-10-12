import 'package:droid/shared/lib/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/auth_api.dart';
import '../api/auth_api_provider.dart';
import 'user.dart';

/// User yang sedang masuk. `null` berarti belum sign in.
///
/// Saat app mulai, sesi dipulihkan dari token di [TokenStore]; selama proses
/// itu state-nya loading dan router menahan di splash.
class CurrentUserNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    final tokens = ref.read(tokenStoreProvider);
    final token = await tokens.read();
    if (token == null) return null;

    try {
      final user = await ref.read(authApiProvider).me(token);
      if (user == null) await tokens.clear();
      return user;
    } on AuthException {
      await tokens.clear();
      return null;
    }
  }

  void set(User user) => state = AsyncData(user);

  void clear() => state = const AsyncData(null);
}

final currentUserProvider =
    AsyncNotifierProvider<CurrentUserNotifier, User?>(CurrentUserNotifier.new);
