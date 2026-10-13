import 'package:droid/features/toggle_theme/index.dart';
import 'package:material_ui/material_ui.dart';

/// Composite block: AppBar standar aplikasi yang menyertakan feature toggle tema.
class DroidAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DroidAppBar({required this.title, super.key});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(title), actions: const [ToggleThemeButton()]);
  }
}
