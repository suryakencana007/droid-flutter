import 'package:droid/features/sign_up/index.dart';
import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:droid/widgets/auth_layout/index.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Buat akun',
      subtitle: 'Gratis dan hanya butuh satu menit.',
      footer: FButton(
        variant: FButtonVariant.ghost,
        onPress: () => context.go(AppRoutes.signIn),
        child: const Text('Sudah punya akun? Masuk'),
      ),
      child: const SignUpForm(),
    );
  }
}
