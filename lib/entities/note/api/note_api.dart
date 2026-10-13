import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/lib/index.dart';

import '../model/note.dart';

abstract interface class NoteApi {
  Future<Paginated<Note>> list({int page = 1, int pageSize = 20});
  Future<Note> get(String id);
  Future<Note> create(NoteDraft draft);
  Future<Note> update(String id, NoteDraft draft);
  Future<void> delete(String id);
}

class NoteNotFoundException implements Exception, DescribableError {
  const NoteNotFoundException(this.id);

  final String id;

  @override
  String describe(AppLocalizations l10n) => l10n.errorNotFound;

  @override
  String toString() => 'NoteNotFoundException($id)';
}
