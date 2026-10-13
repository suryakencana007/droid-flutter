import 'dart:convert';

import '../model/user.dart';
import 'auth_api.dart';

/// Backend auth in-memory untuk pengembangan dan test.
///
/// Akun demo: `demo@example.com` / `password123`. Token bersifat
/// self-describing (berisi email) supaya sesi tetap pulih setelah app
/// di-restart walau instance ini baru; akun hasil sign up tidak bertahan.
class FakeAuthApi implements AuthApi {
  FakeAuthApi({
    this.latency = const Duration(milliseconds: 600),
    Map<String, ({User user, String password})>? accounts,
  }) : _accounts = {...accounts ?? _seed()};

  static const demoEmail = 'demo@example.com';
  static const demoPassword = 'password123';

  final Duration latency;
  final Map<String, ({User user, String password})> _accounts;
  final Set<String> _revoked = {};

  static Map<String, ({User user, String password})> _seed() => {
    demoEmail: (
      user: const User(id: '1', name: 'Demo', email: demoEmail),
      password: demoPassword,
    ),
  };

  Future<void> _wait() => Future<void>.delayed(latency);

  static const _prefix = 'fake.';

  String _issueToken(String email) =>
      '$_prefix${base64Url.encode(utf8.encode(email))}';

  String? _emailOf(String token) {
    if (!token.startsWith(_prefix) || _revoked.contains(token)) return null;
    try {
      return utf8.decode(base64Url.decode(token.substring(_prefix.length)));
    } on FormatException {
      return null;
    }
  }

  @override
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    await _wait();
    final account = _accounts[email.trim().toLowerCase()];
    if (account == null || account.password != password) {
      throw const AuthException(
        'invalid-credentials',
        'Email atau password salah.',
      );
    }
    return AuthResult(
      token: _issueToken(account.user.email),
      user: account.user,
    );
  }

  @override
  Future<AuthResult> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await _wait();
    final key = email.trim().toLowerCase();
    if (_accounts.containsKey(key)) {
      throw const AuthException('email-in-use', 'Email sudah terdaftar.');
    }
    final user = User(
      id: '${_accounts.length + 1}',
      name: name.trim(),
      email: key,
    );
    _accounts[key] = (user: user, password: password);
    return AuthResult(token: _issueToken(key), user: user);
  }

  @override
  Future<User?> me(String token) async {
    await _wait();
    final email = _emailOf(token);
    return email == null ? null : _accounts[email]?.user;
  }

  @override
  Future<void> signOut(String token) async {
    await _wait();
    _revoked.add(token);
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    // Selalu sukses agar tidak membocorkan email mana yang terdaftar.
    await _wait();
  }
}
