import 'package:droid/entities/user/index.dart';
import 'package:droid/shared/l10n/index.dart';
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
    final l10n = context.l10n;

    if (state.value ?? false) {
      return FAlert(
        icon: const Icon(FLucideIcons.mailCheck),
        title: Text(l10n.forgotSentTitle),
        subtitle: Text(l10n.forgotSentBody(_email.text.trim())),
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FTextFormField.email(
            control: FTextFieldControl.managed(controller: _email),
            label: Text(l10n.emailLabel),
            hint: l10n.emailHint,
            textInputAction: TextInputAction.done,
            onSubmit: (_) => _submit(),
            validator: Validators.compose([
              Validators.required(l10n.validationRequired),
              Validators.email(l10n.validationEmail),
            ]),
          ),
          if (state.hasError) ...[
            const Gap(AppSpacing.md),
            FAlert(
              variant: FAlertVariant.destructive,
              icon: const Icon(FLucideIcons.circleAlert),
              title: Text(l10n.forgotFailed),
              subtitle: Text(describeAuthError(state.error!, l10n)),
            ),
          ],
          const Gap(AppSpacing.lg),
          FButton(
            onPress: state.isLoading ? null : _submit,
            child: Text(state.isLoading ? l10n.forgotSending : l10n.forgotSend),
          ),
        ],
      ),
    );
  }
}
