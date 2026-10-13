import 'package:droid/features/forgot_password/index.dart';
import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:droid/widgets/auth_layout/index.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AuthLayout(
      title: l10n.forgotTitle,
      subtitle: l10n.forgotSubtitle,
      footer: FButton(
        variant: FButtonVariant.ghost,
        prefix: const Icon(FLucideIcons.arrowLeft),
        onPress: () => context.go(AppRoutes.signIn),
        child: Text(l10n.backToSignIn),
      ),
      child: const ForgotPasswordForm(),
    );
  }
}
