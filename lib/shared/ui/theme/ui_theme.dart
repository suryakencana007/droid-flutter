import 'package:forui/forui.dart';

/// Tema forui untuk aplikasi. Target hanya Android/iOS, jadi varian `touch`.
///
/// Untuk tema custom: `dart run forui theme create` (atau `just theme`), lalu
/// ganti preset di bawah dengan hasil generate.
abstract final class UiTheme {
  static FThemeData get light => FTheme.neutral.light.touch;
  static FThemeData get dark => FTheme.neutral.dark.touch;
}
