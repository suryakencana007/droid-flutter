import 'package:droid/entities/user/index.dart';
import 'package:droid/features/sign_in/index.dart';
import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:droid/widgets/auth_layout/index.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return AuthLayout(
      title: 'Masuk',
      subtitle: 'Selamat datang kembali di ${AppInfo.name}.',
      footer: FButton(
        variant: FButtonVariant.ghost,
        onPress: () => context.go(AppRoutes.signUp),
        child: const Text('Belum punya akun? Daftar'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SignInForm(),
          const Gap(AppSpacing.sm),
          FButton(
            variant: FButtonVariant.ghost,
            onPress: () => context.go(AppRoutes.forgotPassword),
            child: const Text('Lupa password?'),
          ),
          const Gap(AppSpacing.md),
          Text(
            'Akun demo: ${FakeAuthApi.demoEmail} / ${FakeAuthApi.demoPassword}',
            textAlign: TextAlign.center,
            style: theme.typography.body.xs
                .copyWith(color: theme.colors.mutedForeground),
          ),
        ],
      ),
    );
  }
}
