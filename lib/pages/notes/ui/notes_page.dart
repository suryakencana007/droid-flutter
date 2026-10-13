import 'package:droid/entities/note/index.dart';
import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:droid/widgets/app_bar/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Daftar catatan: pull-to-refresh, infinite scroll, state kosong/error.
class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.position.extentAfter < 300) _loadMore();
  }

  Future<void> _loadMore() async {
    try {
      await ref.read(notesProvider.notifier).loadMore();
    } on Exception {
      if (mounted) {
        showFToast(context: context, title: Text(context.l10n.loadMoreFailed));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final notes = ref.watch(notesProvider);
    final canCreate = ref.watch(flagProvider('notes_create_enabled'));

    return Scaffold(
      appBar: DroidAppBar(title: l10n.notesTitle),
      floatingActionButton: canCreate
          ? FButton.icon(
              variant: FButtonVariant.primary,
              semanticsLabel: l10n.noteNew,
              onPress: () => context.go(AppRoutes.noteNew),
              child: const Icon(FLucideIcons.plus),
            )
          : null,
      body: AsyncValueView<Paginated<Note>>(
        value: notes,
        onRetry: () => ref.invalidate(notesProvider),
        isEmpty: (page) => page.items.isEmpty,
        empty: EmptyView(
          icon: FLucideIcons.notebookPen,
          title: l10n.notesEmptyTitle,
          body: l10n.notesEmptyBody,
        ),
        data: (page) => RefreshIndicator(
          onRefresh: () => ref.read(notesProvider.notifier).refresh(),
          child: ListView.separated(
            controller: _scroll,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: page.items.length + (page.hasMore ? 1 : 0),
            separatorBuilder: (_, _) => const Gap(AppSpacing.sm),
            itemBuilder: (context, index) {
              if (index >= page.items.length) {
                return const Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: LoadingView(),
                );
              }
              final note = page.items[index];
              return NoteTile(
                note: note,
                onPress: () => context.go(AppRoutes.noteDetail(note.id)),
              );
            },
          ),
        ),
      ),
    );
  }
}
