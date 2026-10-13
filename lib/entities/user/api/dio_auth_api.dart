import 'package:dio/dio.dart';
import 'package:droid/shared/api/index.dart';

import '../model/user.dart';
import 'auth_api.dart';

/// Implementasi REST untuk kontrak sederhana:
///
/// | Method | Path                   | Body / header             | Respons            |
/// |--------|------------------------|---------------------------|--------------------|
/// | POST   | /auth/sign-in          | {email, password}         | {token, user}      |
/// | POST   | /auth/sign-up          | {name, email, password}   | {token, user}      |
/// | GET    | /auth/me               | Authorization: Bearer     | user               |
/// | POST   | /auth/sign-out         | Authorization: Bearer     | 204                |
/// | POST   | /auth/password-reset   | {email}                   | 204                |
///
/// `user` = `{id, name, email}`. Sesuaikan [_parseResult] dan path bila
/// backend berbeda; feature dan page tidak perlu berubah.
class DioAuthApi implements AuthApi {
  const DioAuthApi(this._dio);

  final Dio _dio;

  @override
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) => _guard(() async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/sign-in',
      data: {'email': email, 'password': password},
    );
    return _parseResult(res.data!);
  }, unauthorizedAs: 'invalid-credentials');

  @override
  Future<AuthResult> signUp({
    required String name,
    required String email,
    required String password,
  }) => _guard(() async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/sign-up',
      data: {'name': name, 'email': email, 'password': password},
    );
    return _parseResult(res.data!);
  }, conflictAs: 'email-in-use');

  @override
  Future<User?> me(String token) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/auth/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return User.fromJson(res.data!);
    } on DioException catch (e) {
      final api = ApiException.fromDio(e);
      if (api.kind == ApiErrorKind.unauthorized) return null;
      throw _toAuth(api);
    }
  }

  @override
  Future<void> signOut(String token) => _guard(() async {
    await _dio.post<void>(
      '/auth/sign-out',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  });

  @override
  Future<void> requestPasswordReset(String email) => _guard(() async {
    await _dio.post<void>('/auth/password-reset', data: {'email': email});
  });

  AuthResult _parseResult(Map<String, dynamic> json) => AuthResult(
    token: json['token'] as String,
    user: User.fromJson(json['user'] as Map<String, dynamic>),
  );

  Future<T> _guard<T>(
    Future<T> Function() body, {
    String? unauthorizedAs,
    String? conflictAs,
  }) async {
    try {
      return await body();
    } on DioException catch (e) {
      final api = ApiException.fromDio(e);
      if (unauthorizedAs != null && api.kind == ApiErrorKind.unauthorized) {
        throw AuthException(unauthorizedAs, api.message ?? unauthorizedAs);
      }
      if (conflictAs != null && api.statusCode == 409) {
        throw AuthException(conflictAs, api.message ?? conflictAs);
      }
      throw _toAuth(api);
    }
  }

  /// Error jaringan dibungkus sebagai [AuthException] dengan [cause] supaya
  /// `describeAuthError` bisa memakai pesan terlokalisasi [ApiException].
  AuthException _toAuth(ApiException api) =>
      AuthException(api.kind.name, api.message ?? api.kind.name, cause: api);
}
