import 'package:droid/features/change_password/index.dart';
import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.changePasswordTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ChangePasswordForm(
          onChanged: () {
            showFToast(context: context, title: Text(l10n.passwordChanged));
            context.go(AppRoutes.profile);
          },
        ),
      ),
    );
  }
}
