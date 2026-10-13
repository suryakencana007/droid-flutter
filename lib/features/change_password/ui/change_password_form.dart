import 'package:droid/entities/user/index.dart';
import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../model/change_password_controller.dart';

class ChangePasswordForm extends ConsumerStatefulWidget {
  const ChangePasswordForm({required this.onChanged, super.key});

  final VoidCallback onChanged;

  @override
  ConsumerState<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends ConsumerState<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final ok = await ref
        .read(changePasswordControllerProvider.notifier)
        .submit(current: _current.text, next: _next.text);
    if (ok) widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(changePasswordControllerProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FTextFormField.password(
            control: FTextFieldControl.managed(controller: _current),
            label: Text(l10n.currentPasswordLabel),
            validator: Validators.required(l10n.validationRequired),
          ),
          const Gap(AppSpacing.md),
          FTextFormField.password(
            control: FTextFieldControl.managed(controller: _next),
            label: Text(l10n.newPasswordLabel),
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
              Validators.match(() => _next.text, l10n.passwordMismatch),
            ]),
          ),
          if (state.hasError) ...[
            const Gap(AppSpacing.md),
            FAlert(
              variant: FAlertVariant.destructive,
              icon: const Icon(FLucideIcons.circleAlert),
              title: Text(l10n.changePasswordFailed),
              subtitle: Text(describeAuthError(state.error!, l10n)),
            ),
          ],
          const Gap(AppSpacing.lg),
          FButton(
            onPress: state.isLoading ? null : _submit,
            child: Text(state.isLoading ? l10n.saving : l10n.save),
          ),
        ],
      ),
    );
  }
}
