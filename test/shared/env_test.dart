import 'package:droid/shared/config/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('tanpa dart-define flavor adalah dev dengan fake API', () {
    // `just test` meneruskan env/dev.json; `flutter test` polos memakai default.
    expect(Env.flavor, AppFlavor.dev);
    expect(Env.useFakeApi, isTrue);
    expect(Env.isProd, isFalse);
  });
}
