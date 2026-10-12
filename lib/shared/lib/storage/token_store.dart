import 'secure_store.dart';

/// Menyimpan token sesi di [SecureStore]. Dipakai oleh entity user untuk
/// memulihkan sesi dan oleh `shared/api` untuk header Authorization.
class TokenStore {
  const TokenStore(this._store);

  static const _key = 'auth_token';

  final SecureStore _store;

  Future<String?> read() => _store.read(_key);
  Future<void> write(String token) => _store.write(_key, token);
  Future<void> clear() => _store.delete(_key);
}
