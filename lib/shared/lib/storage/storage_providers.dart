import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'key_value_store.dart';
import 'secure_store.dart';
import 'token_store.dart';

/// Override provider ini di test atau prototipe dengan implementasi memory:
/// `keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore())`.
final keyValueStoreProvider =
    Provider<KeyValueStore>((_) => SharedPrefsKeyValueStore());

final secureStoreProvider =
    Provider<SecureStore>((_) => const FlutterSecureStore());

final tokenStoreProvider =
    Provider<TokenStore>((ref) => TokenStore(ref.watch(secureStoreProvider)));
