import 'package:droid/entities/user/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../model/forgot_password_controller.dart';

class ForgotPasswordForm extends ConsumerStatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  ConsumerState<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends ConsumerState<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(forgotPasswordControllerProvider.notifier).submit(_email.text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordControllerProvider);

    if (state.value ?? false) {
      return FAlert(
        icon: const Icon(FLucideIcons.mailCheck),
        title: const Text('Periksa email kamu'),
        subtitle: Text(
          'Jika ${_email.text.trim()} terdaftar, tautan reset password sudah dikirim.',
        ),
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FTextFormField.email(
            control: FTextFieldControl.managed(controller: _email),
            hint: 'nama@contoh.com',
            textInputAction: TextInputAction.done,
            onSubmit: (_) => _submit(),
            validator: Validators.compose([
              Validators.required(),
              Validators.email(),
            ]),
          ),
          if (state.hasError) ...[
            const Gap(AppSpacing.md),
            FAlert(
              variant: FAlertVariant.destructive,
              icon: const Icon(FLucideIcons.circleAlert),
              title: const Text('Gagal mengirim'),
              subtitle: Text(describeAuthError(state.error!)),
            ),
          ],
          const Gap(AppSpacing.lg),
          FButton(
            onPress: state.isLoading ? null : _submit,
            child: Text(state.isLoading ? 'Mengirim...' : 'Kirim tautan reset'),
          ),
        ],
      ),
    );
  }
}
