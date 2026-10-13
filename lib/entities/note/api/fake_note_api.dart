import 'package:droid/shared/lib/index.dart';

import '../model/note.dart';
import 'note_api.dart';

/// Catatan in-memory: 40 contoh, hilang saat app ditutup.
class FakeNoteApi implements NoteApi {
  FakeNoteApi({
    this.latency = const Duration(milliseconds: 400),
    int seedCount = 40,
  }) : _notes = {for (final n in _seed(seedCount)) n.id: n};

  final Duration latency;
  final Map<String, Note> _notes;
  var _nextId = 1000;

  static List<Note> _seed(int count) {
    final base = DateTime(2026, 10, 1, 9);
    return [
      for (var i = 1; i <= count; i++)
        Note(
          id: '$i',
          title: 'Catatan $i',
          body:
              'Isi catatan ke-$i. Lorem ipsum dolor sit amet, consectetur '
              'adipiscing elit, sed do eiusmod tempor incididunt ut labore.',
          createdAt: base.add(Duration(hours: i)),
          updatedAt: base.add(Duration(hours: i, minutes: 30)),
        ),
    ];
  }

  Future<void> _wait() => Future<void>.delayed(latency);

  List<Note> get _sorted =>
      _notes.values.toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

  @override
  Future<Paginated<Note>> list({int page = 1, int pageSize = 20}) async {
    await _wait();
    final all = _sorted;
    final start = (page - 1) * pageSize;
    final items = start >= all.length
        ? <Note>[]
        : all.sublist(start, (start + pageSize).clamp(0, all.length));
    return Paginated(
      items: items,
      page: page,
      hasMore: start + pageSize < all.length,
    );
  }

  @override
  Future<Note> get(String id) async {
    await _wait();
    return _notes[id] ?? (throw NoteNotFoundException(id));
  }

  @override
  Future<Note> create(NoteDraft draft) async {
    await _wait();
    final now = DateTime.now();
    final note = Note(
      id: '${_nextId++}',
      title: draft.title.trim(),
      body: draft.body.trim(),
      createdAt: now,
      updatedAt: now,
    );
    _notes[note.id] = note;
    return note;
  }

  @override
  Future<Note> update(String id, NoteDraft draft) async {
    await _wait();
    final existing = _notes[id] ?? (throw NoteNotFoundException(id));
    final updated = existing.copyWith(
      title: draft.title.trim(),
      body: draft.body.trim(),
      updatedAt: DateTime.now(),
    );
    _notes[id] = updated;
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    await _wait();
    if (_notes.remove(id) == null) throw NoteNotFoundException(id);
  }
}
