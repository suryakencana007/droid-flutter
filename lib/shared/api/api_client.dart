import 'package:dio/dio.dart';
import 'package:droid/shared/lib/logging/app_logger.dart';
import 'package:droid/shared/lib/storage/storage_providers.dart';
import 'package:droid/shared/lib/storage/token_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/env.dart';
import 'api_exception.dart';
import 'session_expired.dart';

/// Menyisipkan `Authorization: Bearer <token>` bila token tersimpan.
class AuthInterceptor extends Interceptor {
  const AuthInterceptor(this._tokens);

  final TokenStore _tokens;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!options.headers.containsKey('Authorization')) {
      final token = await _tokens.read();
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

/// Menormalisasi [DioException] menjadi [ApiException] di `error`.
class ErrorInterceptor extends Interceptor {
  const ErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err.copyWith(error: ApiException.fromDio(err)));
  }
}

/// Memanggil [onUnauthorized] saat server menjawab 401 untuk request yang
/// bukan proses masuk/daftar (di sana 401 berarti kredensial salah).
class UnauthorizedInterceptor extends Interceptor {
  const UnauthorizedInterceptor({
    required this.onUnauthorized,
    this.ignoredPaths = const ['/auth/sign-in', '/auth/sign-up'],
  });

  final void Function() onUnauthorized;
  final List<String> ignoredPaths;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final path = err.requestOptions.path;
    if (err.response?.statusCode == 401 &&
        !ignoredPaths.any(path.startsWith)) {
      onUnauthorized();
    }
    handler.next(err);
  }
}

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.addAll([
    AuthInterceptor(ref.watch(tokenStoreProvider)),
    UnauthorizedInterceptor(
      onUnauthorized: () => ref.read(sessionExpiredProvider.notifier).bump(),
    ),
    const ErrorInterceptor(),
  ]);
  if (Env.isDebug) {
    final httpLog = log('http');
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: httpLog.fine,
    ));
  }

  ref.onDispose(dio.close);
  return dio;
});
