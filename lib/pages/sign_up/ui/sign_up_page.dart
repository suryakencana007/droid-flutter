import 'package:droid/features/sign_up/index.dart';
import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:droid/widgets/auth_layout/index.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AuthLayout(
      title: l10n.signUpTitle,
      subtitle: l10n.signUpSubtitle,
      footer: FButton(
        variant: FButtonVariant.ghost,
        onPress: () => context.go(AppRoutes.signIn),
        child: Text(l10n.haveAccountLink),
      ),
      child: const SignUpForm(),
    );
  }
}
