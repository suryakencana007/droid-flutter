import 'package:droid/entities/note/index.dart';
import 'package:droid/features/delete_note/index.dart';
import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class NoteDetailPage extends ConsumerWidget {
  const NoteDetailPage({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = context.theme;
    final note = ref.watch(noteProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notesTitle),
        actions: [
          FButton.icon(
            variant: FButtonVariant.ghost,
            semanticsLabel: l10n.edit,
            onPress: () => context.go(AppRoutes.noteEdit(id)),
            child: const Icon(FLucideIcons.pencil),
          ),
          const Gap(AppSpacing.sm),
        ],
      ),
      body: AsyncValueView<Note>(
        value: note,
        onRetry: () => ref.invalidate(noteProvider(id)),
        data: (note) => ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Text(
              note.title,
              style: theme.typography.display.xl2.copyWith(
                color: theme.colors.foreground,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
            const Gap(AppSpacing.xs),
            Text(
              l10n.updatedAt(formatNoteDate(context, note.updatedAt)),
              style: theme.typography.body.xs.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
            const Gap(AppSpacing.lg),
            Text(
              note.body,
              style: theme.typography.body.md.copyWith(
                color: theme.colors.foreground,
                height: 1.6,
              ),
            ),
            const Gap(AppSpacing.xl),
            DeleteNoteButton(
              noteId: note.id,
              onDeleted: () => context.go(AppRoutes.notes),
            ),
          ],
        ),
      ),
    );
  }
}
