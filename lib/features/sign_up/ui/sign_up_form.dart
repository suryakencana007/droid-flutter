import 'package:droid/entities/user/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../model/sign_up_controller.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(signUpControllerProvider.notifier).submit(
          name: _name.text,
          email: _email.text,
          password: _password.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpControllerProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FTextFormField(
            control: FTextFieldControl.managed(controller: _name),
            label: const Text('Nama'),
            hint: 'Nama lengkap',
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            validator: Validators.required(),
          ),
          const Gap(AppSpacing.md),
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
            description: const Text('Minimal 8 karakter'),
            validator: Validators.compose([
              Validators.required(),
              Validators.minLength(8),
            ]),
          ),
          const Gap(AppSpacing.md),
          FTextFormField.password(
            control: FTextFieldControl.managed(controller: _confirm),
            label: const Text('Ulangi password'),
            textInputAction: TextInputAction.done,
            onSubmit: (_) => _submit(),
            validator: Validators.compose([
              Validators.required(),
              Validators.match(() => _password.text, message: 'Password tidak sama'),
            ]),
          ),
          if (state.hasError) ...[
            const Gap(AppSpacing.md),
            FAlert(
              variant: FAlertVariant.destructive,
              icon: const Icon(FLucideIcons.circleAlert),
              title: const Text('Gagal mendaftar'),
              subtitle: Text(describeAuthError(state.error!)),
            ),
          ],
          const Gap(AppSpacing.lg),
          FButton(
            onPress: state.isLoading ? null : _submit,
            child: Text(state.isLoading ? 'Memproses...' : 'Daftar'),
          ),
        ],
      ),
    );
  }
}
