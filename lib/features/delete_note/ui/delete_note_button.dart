import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../model/delete_note_controller.dart';

class DeleteNoteButton extends ConsumerWidget {
  const DeleteNoteButton({required this.noteId, required this.onDeleted, super.key});

  final String noteId;
  final VoidCallback onDeleted;

  Future<void> _confirm(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final ok = await showConfirmDialog(
      context,
      title: l10n.noteDeleteConfirmTitle,
      message: l10n.noteDeleteConfirmBody,
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
      destructive: true,
    );
    if (!ok) return;
    final deleted =
        await ref.read(deleteNoteControllerProvider.notifier).delete(noteId);
    if (!context.mounted) return;
    if (deleted) {
      showFToast(context: context, title: Text(l10n.noteDeleted));
      onDeleted();
    } else {
      final error = ref.read(deleteNoteControllerProvider).error!;
      showFToast(context: context, title: Text(describeError(error, l10n)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(deleteNoteControllerProvider);
    final l10n = context.l10n;

    return FButton(
      variant: FButtonVariant.destructive,
      prefix: const Icon(FLucideIcons.trash2),
      onPress: state.isLoading ? null : () => _confirm(context, ref),
      child: Text(state.isLoading ? l10n.deleting : l10n.delete),
    );
  }
}
