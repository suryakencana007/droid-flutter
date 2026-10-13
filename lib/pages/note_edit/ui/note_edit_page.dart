import 'package:droid/entities/note/index.dart';
import 'package:droid/features/create_note/index.dart';
import 'package:droid/features/edit_note/index.dart';
import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// `/notes/new` (id null) membuat catatan; `/notes/:id/edit` mengubahnya.
class NoteEditPage extends ConsumerWidget {
  const NoteEditPage({super.key, this.id});

  final String? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final id = this.id;

    return Scaffold(
      appBar: AppBar(title: Text(id == null ? l10n.noteNew : l10n.noteEdit)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: id == null
            ? CreateNoteForm(
                onCreated: (note) {
                  showFToast(context: context, title: Text(l10n.noteSaved));
                  context.go(AppRoutes.noteDetail(note.id));
                },
              )
            : AsyncValueView<Note>(
                value: ref.watch(noteProvider(id)),
                onRetry: () => ref.invalidate(noteProvider(id)),
                data: (note) => EditNoteForm(
                  note: note,
                  onSaved: (saved) {
                    showFToast(context: context, title: Text(l10n.noteSaved));
                    context.go(AppRoutes.noteDetail(saved.id));
                  },
                ),
              ),
      ),
    );
  }
}
