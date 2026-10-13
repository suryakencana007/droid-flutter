import 'package:droid/entities/user/index.dart';
import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../model/edit_profile_controller.dart';

class EditProfileForm extends ConsumerStatefulWidget {
  const EditProfileForm({required this.user, required this.onSaved, super.key});

  final User user;
  final VoidCallback onSaved;

  @override
  ConsumerState<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends ConsumerState<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.user.name);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final ok = await ref
        .read(editProfileControllerProvider.notifier)
        .submit(name: _name.text);
    if (ok) widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(editProfileControllerProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FTextFormField(
            control: FTextFieldControl.managed(controller: _name),
            label: Text(l10n.nameLabel),
            hint: l10n.nameHint,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            onSubmit: (_) => _submit(),
            validator: Validators.required(l10n.validationRequired),
          ),
          const Gap(AppSpacing.md),
          FTextFormField.email(
            control: FTextFieldControl.managed(
              controller: TextEditingController(text: widget.user.email),
            ),
            label: Text(l10n.emailLabel),
            enabled: false,
          ),
          if (state.hasError) ...[
            const Gap(AppSpacing.md),
            FAlert(
              variant: FAlertVariant.destructive,
              icon: const Icon(FLucideIcons.circleAlert),
              title: Text(l10n.editProfileFailed),
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
