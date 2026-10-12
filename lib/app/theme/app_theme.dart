import 'package:droid/shared/ui/index.dart';
import 'package:material_ui/material_ui.dart';

/// Tema Material diturunkan dari tema forui supaya widget Material yang masih
/// dipakai (Scaffold, AppBar) selaras warnanya dengan komponen forui.
abstract final class AppTheme {
  static ThemeData get light => UiTheme.light.toApproximateMaterialTheme();
  static ThemeData get dark => UiTheme.dark.toApproximateMaterialTheme();
}
