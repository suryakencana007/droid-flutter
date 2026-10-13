import 'package:droid/entities/user/index.dart';
import 'package:droid/features/sign_in/index.dart';
import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:droid/widgets/auth_layout/index.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return AuthLayout(
      title: l10n.signInTitle,
      subtitle: l10n.signInSubtitle(AppInfo.name),
      footer: FButton(
        variant: FButtonVariant.ghost,
        onPress: () => context.go(AppRoutes.signUp),
        child: Text(l10n.noAccountLink),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SignInForm(),
          const Gap(AppSpacing.sm),
          FButton(
            variant: FButtonVariant.ghost,
            onPress: () => context.go(AppRoutes.forgotPassword),
            child: Text(l10n.forgotPasswordLink),
          ),
          const Gap(AppSpacing.md),
          Text(
            l10n.demoAccountHint(
              FakeAuthApi.demoEmail,
              FakeAuthApi.demoPassword,
            ),
            textAlign: TextAlign.center,
            style: theme.typography.body.xs.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
