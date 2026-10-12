import 'package:droid/shared/lib/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Apakah user sudah menyelesaikan onboarding. Disimpan di [KeyValueStore].
class OnboardingNotifier extends AsyncNotifier<bool> {
  static const _key = 'onboarding_done';

  @override
  Future<bool> build() async =>
      await ref.read(keyValueStoreProvider).getBool(_key) ?? false;

  Future<void> complete() async {
    await ref.read(keyValueStoreProvider).setBool(_key, true);
    state = const AsyncData(true);
  }

  /// Untuk debugging atau tombol "lihat onboarding lagi".
  Future<void> reset() async {
    await ref.read(keyValueStoreProvider).remove(_key);
    state = const AsyncData(false);
  }
}

final onboardingDoneProvider =
    AsyncNotifierProvider<OnboardingNotifier, bool>(OnboardingNotifier.new);
