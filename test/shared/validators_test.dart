import 'package:droid/shared/lib/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators', () {
    test('required menolak kosong dan spasi', () {
      final v = Validators.required();
      expect(v(null), isNotNull);
      expect(v('   '), isNotNull);
      expect(v('a'), isNull);
    });

    test('email memvalidasi format tapi membiarkan kosong', () {
      final v = Validators.email();
      expect(v(''), isNull);
      expect(v('bukan-email'), isNotNull);
      expect(v('a@b.co'), isNull);
    });

    test('minLength dan match', () {
      expect(Validators.minLength(8)('1234567'), isNotNull);
      expect(Validators.minLength(8)('12345678'), isNull);
      expect(Validators.match(() => 'x')('y'), isNotNull);
      expect(Validators.match(() => 'x')('x'), isNull);
    });

    test('compose mengembalikan error pertama', () {
      final v = Validators.compose([Validators.required(), Validators.email()]);
      expect(v(''), 'Wajib diisi');
      expect(v('salah'), 'Format email tidak valid');
      expect(v('a@b.co'), isNull);
    });
  });
}
