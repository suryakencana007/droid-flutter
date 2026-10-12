import '../model/user.dart';

/// Hasil sign in / sign up: token sesi dan profil user.
class AuthResult {
  const AuthResult({required this.token, required this.user});

  final String token;
  final User user;
}

/// Kegagalan auth yang bisa ditampilkan ke user. [code] stabil untuk logika,
/// [message] untuk UI.
class AuthException implements Exception {
  const AuthException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => 'AuthException($code): $message';
}

/// Kontrak backend auth. Implementasi default: [FakeAuthApi]. Ganti lewat
/// `authApiProvider` untuk Dio, Supabase, Firebase, dan lain-lain.
abstract interface class AuthApi {
  Future<AuthResult> signIn({required String email, required String password});

  Future<AuthResult> signUp({
    required String name,
    required String email,
    required String password,
  });

  /// Profil pemilik [token], atau `null` jika token tidak dikenal/kedaluwarsa.
  Future<User?> me(String token);

  Future<void> signOut(String token);

  Future<void> requestPasswordReset(String email);
}
