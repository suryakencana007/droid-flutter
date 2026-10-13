import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';
part 'note.g.dart';

@freezed
abstract class Note with _$Note {
  const Note._();

  const factory Note({
    required String id,
    required String title,
    required String body,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  /// Cuplikan isi untuk daftar.
  String get excerpt {
    final flat = body.replaceAll(RegExp(r'\s+'), ' ').trim();
    return flat.length <= 80 ? flat : '${flat.substring(0, 80)}…';
  }
}

/// Input buat/ubah catatan.
@freezed
abstract class NoteDraft with _$NoteDraft {
  const factory NoteDraft({required String title, required String body}) =
      _NoteDraft;

  factory NoteDraft.fromJson(Map<String, dynamic> json) =>
      _$NoteDraftFromJson(json);
}
