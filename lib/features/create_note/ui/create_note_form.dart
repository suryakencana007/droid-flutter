import 'package:droid/entities/note/index.dart';
import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../model/create_note_controller.dart';

class CreateNoteForm extends ConsumerWidget {
  const CreateNoteForm({required this.onCreated, super.key});

  final void Function(Note note) onCreated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createNoteControllerProvider);

    return NoteForm(
      submitting: state.isLoading,
      error: state.hasError ? describeError(state.error!, context.l10n) : null,
      onSubmit: (draft) async {
        final note =
            await ref.read(createNoteControllerProvider.notifier).submit(draft);
        if (note != null) onCreated(note);
      },
    );
  }
}
