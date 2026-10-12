import 'package:droid/entities/user/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeAuthApi api;

  setUp(() => api = FakeAuthApi(latency: Duration.zero));

  test('sign in dengan akun demo mengembalikan token yang dikenali me()',
      () async {
    final result = await api.signIn(
      email: FakeAuthApi.demoEmail,
      password: FakeAuthApi.demoPassword,
    );
    expect(result.user.name, 'Demo');
    expect(await api.me(result.token), result.user);

    await api.signOut(result.token);
    expect(await api.me(result.token), isNull);
  });

  test('token dikenali oleh instance baru (sesi pulih setelah restart)',
      () async {
    final result = await api.signIn(
      email: FakeAuthApi.demoEmail,
      password: FakeAuthApi.demoPassword,
    );
    final fresh = FakeAuthApi(latency: Duration.zero);
    expect(await fresh.me(result.token), result.user);
    expect(await fresh.me('token-asing'), isNull);
  });

  test('password salah melempar AuthException invalid-credentials', () {
    expect(
      () => api.signIn(email: FakeAuthApi.demoEmail, password: 'x'),
      throwsA(isA<AuthException>().having((e) => e.code, 'code', 'invalid-credentials')),
    );
  });

  test('sign up menolak email yang sudah ada', () async {
    await api.signUp(name: 'A', email: 'a@b.co', password: 'p');
    expect(
      () => api.signUp(name: 'B', email: 'A@B.CO', password: 'p'),
      throwsA(isA<AuthException>().having((e) => e.code, 'code', 'email-in-use')),
    );
  });

  test('describeAuthError memakai pesan AuthException', () {
    expect(describeAuthError(const AuthException('x', 'Pesan')), 'Pesan');
    expect(describeAuthError(StateError('boom')), isNot(contains('boom')));
  });
}
