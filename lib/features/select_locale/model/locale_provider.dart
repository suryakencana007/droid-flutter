import 'package:droid/shared/lib/index.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Locale pilihan user; `null` berarti mengikuti sistem.
class LocaleNotifier extends AsyncNotifier<Locale?> {
  static const _key = 'locale';

  @override
  Future<Locale?> build() async {
    final raw = await ref.read(keyValueStoreProvider).getString(_key);
    return raw == null ? null : Locale(raw);
  }

  Future<void> set(Locale? locale) async {
    state = AsyncData(locale);
    final store = ref.read(keyValueStoreProvider);
    if (locale == null) {
      await store.remove(_key);
    } else {
      await store.setString(_key, locale.languageCode);
    }
  }
}

final localeProvider = AsyncNotifierProvider<LocaleNotifier, Locale?>(
  LocaleNotifier.new,
);
