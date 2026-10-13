import 'package:droid/entities/user/index.dart';
import 'package:droid/shared/l10n/index.dart';
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
    final l10n = context.l10n;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
            textInputAction: TextInputAction.done,
            label: Text(l10n.passwordLabel),
            onSubmit: (_) => _submit(),
            validator: Validators.required(l10n.validationRequired),
          ),
          if (state.hasError) ...[
            const Gap(AppSpacing.md),
            FAlert(
              variant: FAlertVariant.destructive,
              icon: const Icon(FLucideIcons.circleAlert),
              title: Text(l10n.signInFailed),
              subtitle: Text(describeAuthError(state.error!, l10n)),
            ),
          ],
          const Gap(AppSpacing.lg),
          FButton(
            onPress: state.isLoading ? null : _submit,
            child: Text(
              state.isLoading ? l10n.signInProcessing : l10n.signInAction,
            ),
          ),
        ],
      ),
    );
  }
}
