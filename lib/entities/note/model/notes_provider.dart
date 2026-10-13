import 'package:droid/shared/lib/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/note_api_provider.dart';
import 'note.dart';

/// Daftar catatan berhalaman. Halaman pertama dimuat di [build]; halaman
/// berikutnya lewat [loadMore]. Perubahan lokal ([upsert], [remove]) menjaga
/// daftar tetap sinkron tanpa memuat ulang dari server.
class NotesNotifier extends AsyncNotifier<Paginated<Note>> {
  static const pageSize = 20;

  bool _loadingMore = false;

  @override
  Future<Paginated<Note>> build() =>
      ref.read(noteApiProvider).list();

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(noteApiProvider).list(),
    );
  }

  /// Memuat halaman berikutnya. Melempar bila gagal supaya halaman bisa
  /// menampilkan toast tanpa kehilangan daftar yang sudah ada.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || _loadingMore) return;
    _loadingMore = true;
    try {
      final next = await ref
          .read(noteApiProvider)
          .list(page: current.page + 1);
      state = AsyncData(current.append(next));
    } finally {
      _loadingMore = false;
    }
  }

  void upsert(Note note) {
    final current = state.value;
    if (current == null) return;
    final items = [...current.items]..removeWhere((n) => n.id == note.id);
    state = AsyncData(current.copyWith(items: [note, ...items]));
  }

  void remove(String id) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(items: current.items.where((n) => n.id != id).toList()),
    );
  }
}

final notesProvider =
    AsyncNotifierProvider<NotesNotifier, Paginated<Note>>(NotesNotifier.new);

/// Satu catatan: diambil dari daftar bila sudah ada, selain itu dari API.
final noteProvider = FutureProvider.autoDispose.family<Note, String>((ref, id) {
  final cached = ref.watch(notesProvider).value?.items;
  for (final note in cached ?? const <Note>[]) {
    if (note.id == id) return note;
  }
  return ref.read(noteApiProvider).get(id);
});
