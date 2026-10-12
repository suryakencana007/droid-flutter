/// Satu pintu masuk UI kit untuk seluruh layer.
///
/// Layer lain mengimpor `package:droid/shared/ui/index.dart`, bukan
/// `package:forui` langsung, supaya penggantian atau pembungkusan UI kit cukup
/// dilakukan di sini. Aturan ini dijaga oleh `test/architecture`.
library;

export 'package:forui/forui.dart';
export 'package:forui_lucide/forui_lucide.dart';

export 'app_logo.dart';
export 'confirm_dialog.dart';
export 'gap.dart';
export 'loading_view.dart';
export 'spacing.dart';
export 'theme/ui_theme.dart';
