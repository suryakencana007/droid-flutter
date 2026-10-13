import 'package:droid/entities/note/index.dart';
import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../model/edit_note_controller.dart';

class EditNoteForm extends ConsumerWidget {
  const EditNoteForm({required this.note, required this.onSaved, super.key});

  final Note note;
  final void Function(Note note) onSaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editNoteControllerProvider);

    return NoteForm(
      initial: NoteDraft(title: note.title, body: note.body),
      submitting: state.isLoading,
      error: state.hasError ? describeError(state.error!, context.l10n) : null,
      onSubmit: (draft) async {
        final saved = await ref
            .read(editNoteControllerProvider.notifier)
            .submit(note.id, draft);
        if (saved != null) onSaved(saved);
      },
    );
  }
}
