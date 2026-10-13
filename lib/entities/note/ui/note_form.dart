import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:material_ui/material_ui.dart';

import '../model/note.dart';

/// Form judul + isi. Dipakai feature buat dan ubah; entity tidak tahu apa
/// yang terjadi saat submit.
class NoteForm extends StatefulWidget {
  const NoteForm({
    required this.onSubmit,
    super.key,
    this.initial,
    this.submitting = false,
    this.error,
  });

  final NoteDraft? initial;
  final Future<void> Function(NoteDraft draft) onSubmit;
  final bool submitting;
  final String? error;

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final _formKey = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.initial?.title);
  late final _body = TextEditingController(text: widget.initial?.body);

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await widget.onSubmit(NoteDraft(title: _title.text, body: _body.text));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FTextFormField(
            control: FTextFieldControl.managed(controller: _title),
            label: Text(l10n.noteTitleLabel),
            hint: l10n.noteTitleHint,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
            validator: Validators.required(l10n.validationRequired),
          ),
          const Gap(AppSpacing.md),
          FTextFormField.multiline(
            control: FTextFieldControl.managed(controller: _body),
            label: Text(l10n.noteBodyLabel),
            hint: l10n.noteBodyHint,
            minLines: 6,
            maxLines: 12,
            validator: Validators.required(l10n.validationRequired),
          ),
          if (widget.error != null) ...[
            const Gap(AppSpacing.md),
            FAlert(
              variant: FAlertVariant.destructive,
              icon: const Icon(FLucideIcons.circleAlert),
              title: Text(widget.error!),
            ),
          ],
          const Gap(AppSpacing.lg),
          FButton(
            onPress: widget.submitting ? null : _submit,
            child: Text(widget.submitting ? l10n.saving : l10n.save),
          ),
        ],
      ),
    );
  }
}
