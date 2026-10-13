import 'package:dio/dio.dart';
import 'package:droid/shared/api/index.dart';
import 'package:flutter_test/flutter_test.dart';

DioException _dio(DioExceptionType type, {int? status, Object? data}) {
  final options = RequestOptions(path: '/x');
  return DioException(
    requestOptions: options,
    type: type,
    response: status == null
        ? null
        : Response(requestOptions: options, statusCode: status, data: data),
  );
}

void main() {
  test('memetakan tipe Dio dan status HTTP ke ApiErrorKind', () {
    expect(
      ApiException.fromDio(_dio(DioExceptionType.connectionError)).kind,
      ApiErrorKind.network,
    );
    expect(
      ApiException.fromDio(_dio(DioExceptionType.receiveTimeout)).kind,
      ApiErrorKind.timeout,
    );
    expect(
      ApiException.fromDio(_dio(DioExceptionType.badResponse, status: 401))
          .kind,
      ApiErrorKind.unauthorized,
    );
    expect(
      ApiException.fromDio(_dio(DioExceptionType.badResponse, status: 404))
          .kind,
      ApiErrorKind.notFound,
    );
    expect(
      ApiException.fromDio(_dio(DioExceptionType.badResponse, status: 503))
          .kind,
      ApiErrorKind.server,
    );
  });

  test('mengambil pesan dari body {message} dan mempertahankan error yang sudah dipetakan', () {
    final e = ApiException.fromDio(
      _dio(
        DioExceptionType.badResponse,
        status: 422,
        data: {'message': 'Nope'},
      ),
    );
    expect(e.message, 'Nope');
    expect(e.kind, ApiErrorKind.unknown);

    final wrapped = _dio(DioExceptionType.unknown).copyWith(error: e);
    expect(identical(ApiException.fromDio(wrapped), e), isTrue);
  });
}
