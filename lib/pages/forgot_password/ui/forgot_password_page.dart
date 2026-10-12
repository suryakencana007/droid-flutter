import 'package:droid/features/forgot_password/index.dart';
import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:droid/widgets/auth_layout/index.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Lupa password',
      subtitle: 'Masukkan email, kami kirim tautan untuk mengatur ulang.',
      footer: FButton(
        variant: FButtonVariant.ghost,
        prefix: const Icon(FLucideIcons.arrowLeft),
        onPress: () => context.go(AppRoutes.signIn),
        child: const Text('Kembali ke masuk'),
      ),
      child: const ForgotPasswordForm(),
    );
  }
}
