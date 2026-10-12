import 'package:droid/entities/user/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../model/sign_in_controller.dart';

class SignInForm extends ConsumerStatefulWidget {
  const SignInForm({super.key});

  @override
  ConsumerState<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref
        .read(signInControllerProvider.notifier)
        .submit(email: _email.text, password: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signInControllerProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FTextFormField.email(
            control: FTextFieldControl.managed(controller: _email),
            hint: 'nama@contoh.com',
            validator: Validators.compose([
              Validators.required(),
              Validators.email(),
            ]),
          ),
          const Gap(AppSpacing.md),
          FTextFormField.password(
            control: FTextFieldControl.managed(controller: _password),
            textInputAction: TextInputAction.done,
            onSubmit: (_) => _submit(),
            validator: Validators.required(),
          ),
          if (state.hasError) ...[
            const Gap(AppSpacing.md),
            FAlert(
              variant: FAlertVariant.destructive,
              icon: const Icon(FLucideIcons.circleAlert),
              title: const Text('Gagal masuk'),
              subtitle: Text(describeAuthError(state.error!)),
            ),
          ],
          const Gap(AppSpacing.lg),
          FButton(
            onPress: state.isLoading ? null : _submit,
            child: Text(state.isLoading ? 'Memproses...' : 'Masuk'),
          ),
        ],
      ),
    );
  }
}
