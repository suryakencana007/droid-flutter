import '../api/auth_api.dart';

/// Pesan yang aman ditampilkan ke user untuk error dari [AuthApi].
String describeAuthError(Object error) => switch (error) {
      AuthException(:final message) => message,
      _ => 'Terjadi kesalahan. Coba lagi.',
    };
