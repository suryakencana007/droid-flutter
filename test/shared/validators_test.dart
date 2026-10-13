import 'package:droid/shared/lib/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators', () {
    test('required menolak kosong dan spasi', () {
      final v = Validators.required('wajib');
      expect(v(null), 'wajib');
      expect(v('   '), 'wajib');
      expect(v('a'), isNull);
    });

    test('email memvalidasi format tapi membiarkan kosong', () {
      final v = Validators.email('format');
      expect(v(''), isNull);
      expect(v('bukan-email'), 'format');
      expect(v('a@b.co'), isNull);
    });

    test('minLength dan match', () {
      expect(Validators.minLength(8, 'pendek')('1234567'), 'pendek');
      expect(Validators.minLength(8, 'pendek')('12345678'), isNull);
      expect(Validators.match(() => 'x', 'beda')('y'), 'beda');
      expect(Validators.match(() => 'x', 'beda')('x'), isNull);
    });

    test('compose mengembalikan error pertama', () {
      final v = Validators.compose([
        Validators.required('wajib'),
        Validators.email('format'),
      ]);
      expect(v(''), 'wajib');
      expect(v('salah'), 'format');
      expect(v('a@b.co'), isNull);
    });
  });
}
