import 'package:droid/entities/user/index.dart';
import 'package:droid/shared/l10n/index.dart';
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
    final l10n = context.l10n;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FTextFormField(
            control: FTextFieldControl.managed(controller: _name),
            label: Text(l10n.nameLabel),
            hint: l10n.nameHint,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            validator: Validators.required(l10n.validationRequired),
          ),
          const Gap(AppSpacing.md),
          FTextFormField.email(
            control: FTextFieldControl.managed(controller: _email),
            label: Text(l10n.emailLabel),
            hint: l10n.emailHint,
            validator: Validators.compose([
              Validators.required(l10n.validationRequired),
              Validators.email(l10n.validationEmail),
            ]),
          ),
          const Gap(AppSpacing.md),
          FTextFormField.password(
            control: FTextFieldControl.managed(controller: _password),
            label: Text(l10n.passwordLabel),
            description: Text(l10n.passwordMinHint),
            validator: Validators.compose([
              Validators.required(l10n.validationRequired),
              Validators.minLength(8, l10n.validationMinLength(8)),
            ]),
          ),
          const Gap(AppSpacing.md),
          FTextFormField.password(
            control: FTextFieldControl.managed(controller: _confirm),
            label: Text(l10n.confirmPasswordLabel),
            textInputAction: TextInputAction.done,
            onSubmit: (_) => _submit(),
            validator: Validators.compose([
              Validators.required(l10n.validationRequired),
              Validators.match(() => _password.text, l10n.passwordMismatch),
            ]),
          ),
          if (state.hasError) ...[
            const Gap(AppSpacing.md),
            FAlert(
              variant: FAlertVariant.destructive,
              icon: const Icon(FLucideIcons.circleAlert),
              title: Text(l10n.signUpFailed),
              subtitle: Text(describeAuthError(state.error!, l10n)),
            ),
          ],
          const Gap(AppSpacing.lg),
          FButton(
            onPress: state.isLoading ? null : _submit,
            child: Text(state.isLoading ? l10n.signUpProcessing : l10n.signUpAction),
          ),
        ],
      ),
    );
  }
}
