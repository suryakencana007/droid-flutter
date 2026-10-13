import 'package:dio/dio.dart';
import 'package:droid/shared/lib/errors/describe_error.dart';

import '../l10n/index.dart';

enum ApiErrorKind {
  network,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  server,
  cancelled,
  unknown,
}

/// Error HTTP yang sudah dinormalisasi. Dibuat oleh `ErrorInterceptor` dari
/// [DioException]; layer di atas tidak perlu tahu Dio.
class ApiException implements Exception, DescribableError {
  const ApiException(this.kind, {this.message, this.statusCode, this.data});

  factory ApiException.fromDio(DioException error) {
    if (error.error case final ApiException already) return already;

    final status = error.response?.statusCode;
    final kind = switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        ApiErrorKind.timeout,
      DioExceptionType.connectionError => ApiErrorKind.network,
      DioExceptionType.cancel => ApiErrorKind.cancelled,
      DioExceptionType.badResponse => switch (status) {
          401 => ApiErrorKind.unauthorized,
          403 => ApiErrorKind.forbidden,
          404 => ApiErrorKind.notFound,
          final int s when s >= 500 => ApiErrorKind.server,
          _ => ApiErrorKind.unknown,
        },
      _ => ApiErrorKind.unknown,
    };

    return ApiException(
      kind,
      statusCode: status,
      data: error.response?.data,
      message: _messageFrom(error.response?.data) ?? error.message,
    );
  }

  final ApiErrorKind kind;

  /// Pesan mentah dari server atau Dio; untuk log, bukan untuk user.
  final String? message;
  final int? statusCode;
  final Object? data;

  static String? _messageFrom(Object? body) => switch (body) {
        {'message': final String m} => m,
        {'error': final String m} => m,
        _ => null,
      };

  @override
  String describe(AppLocalizations l10n) => switch (kind) {
        ApiErrorKind.network => l10n.errorNetwork,
        ApiErrorKind.timeout => l10n.errorTimeout,
        ApiErrorKind.unauthorized => l10n.errorUnauthorized,
        ApiErrorKind.notFound => l10n.errorNotFound,
        ApiErrorKind.server => l10n.errorServer,
        _ => l10n.errorGeneric,
      };

  @override
  String toString() => 'ApiException(${kind.name}, $statusCode): $message';
}
