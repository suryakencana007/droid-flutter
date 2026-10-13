import 'package:droid/shared/lib/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('LocalFeatureFlags.parse memahami true/false dan nilai', () {
    final flags = LocalFeatureFlags.parse('a:true; b:false ;c:v2;d');
    expect(flags['a']!.enabled, isTrue);
    expect(flags['b']!.enabled, isFalse);
    expect(flags['c']!.enabled, isTrue);
    expect(flags['c']!.value, 'v2');
    expect(flags['d']!.enabled, isTrue);
    expect(flags.length, 4);
  });
}
