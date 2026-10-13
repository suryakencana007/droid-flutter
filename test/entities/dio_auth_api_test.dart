import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:droid/entities/user/index.dart';
import 'package:droid/shared/api/index.dart';
import 'package:flutter_test/flutter_test.dart';

/// Adapter palsu: path → (status, body JSON). Mencatat request terakhir.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.routes);

  final Map<String, (int, Object?)> routes;
  RequestOptions? last;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    last = options;
    final (status, body) =
        routes[options.path] ?? (404, {'message': 'no route'});
    return ResponseBody.fromString(
      body == null ? '' : jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio _dio(_FakeAdapter adapter) => Dio(BaseOptions(baseUrl: 'https://x'))
  ..httpClientAdapter = adapter
  ..interceptors.add(const ErrorInterceptor());

const _user = {'id': '7', 'name': 'Ani', 'email': 'ani@contoh.com'};

void main() {
  test('sign in sukses mengembalikan token dan user', () async {
    final adapter = _FakeAdapter({
      '/auth/sign-in': (200, {'token': 't-1', 'user': _user}),
    });
    final api = DioAuthApi(_dio(adapter));

    final result = await api.signIn(email: 'ani@contoh.com', password: 'p');
    expect(result.token, 't-1');
    expect(result.user.name, 'Ani');
    expect(adapter.last!.data, {'email': 'ani@contoh.com', 'password': 'p'});
  });

  test('401 saat sign in menjadi invalid-credentials', () {
    final api = DioAuthApi(
      _dio(
        _FakeAdapter({
          '/auth/sign-in': (401, {'message': 'bad'}),
        }),
      ),
    );
    expect(
      () => api.signIn(email: 'a@b.co', password: 'x'),
      throwsA(
        isA<AuthException>().having(
          (e) => e.code,
          'code',
          'invalid-credentials',
        ),
      ),
    );
  });

  test('409 saat sign up menjadi email-in-use', () {
    final api = DioAuthApi(_dio(_FakeAdapter({'/auth/sign-up': (409, null)})));
    expect(
      () => api.signUp(name: 'A', email: 'a@b.co', password: 'x'),
      throwsA(
        isA<AuthException>().having((e) => e.code, 'code', 'email-in-use'),
      ),
    );
  });

  test('me() mengirim bearer token dan mengembalikan null saat 401', () async {
    final adapter = _FakeAdapter({'/auth/me': (200, _user)});
    final api = DioAuthApi(_dio(adapter));
    expect((await api.me('tok'))?.id, '7');
    expect(adapter.last!.headers['Authorization'], 'Bearer tok');

    final expired = DioAuthApi(_dio(_FakeAdapter({'/auth/me': (401, null)})));
    expect(await expired.me('tok'), isNull);
  });

  test('error server dibungkus dengan cause ApiException', () async {
    final api = DioAuthApi(_dio(_FakeAdapter({'/auth/sign-in': (500, null)})));
    try {
      await api.signIn(email: 'a@b.co', password: 'x');
      fail('harus melempar');
    } on AuthException catch (e) {
      expect(e.code, 'server');
      expect(e.cause, isA<ApiException>());
    }
  });
}
