import 'package:dio/dio.dart';
import 'package:droid/shared/api/index.dart';
import 'package:droid/shared/lib/index.dart';

import '../model/note.dart';
import 'note_api.dart';

/// REST sederhana:
///
/// | Method | Path                | Respons                               |
/// |--------|---------------------|---------------------------------------|
/// | GET    | /notes?page&page_size | {items: [note], page, has_more}     |
/// | GET    | /notes/:id          | note                                  |
/// | POST   | /notes              | note (body: {title, body})            |
/// | PUT    | /notes/:id          | note                                  |
/// | DELETE | /notes/:id          | 204                                   |
///
/// `note` = `{id, title, body, createdAt, updatedAt}` (ISO 8601).
class DioNoteApi implements NoteApi {
  const DioNoteApi(this._dio);

  final Dio _dio;

  @override
  Future<Paginated<Note>> list({int page = 1, int pageSize = 20}) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/notes',
      queryParameters: {'page': page, 'page_size': pageSize},
    );
    final data = res.data!;
    return Paginated(
      items: [
        for (final item in data['items'] as List)
          Note.fromJson(item as Map<String, dynamic>),
      ],
      page: data['page'] as int? ?? page,
      hasMore: data['has_more'] as bool? ?? false,
    );
  }

  @override
  Future<Note> get(String id) => _notFoundAs(id, () async {
        final res = await _dio.get<Map<String, dynamic>>('/notes/$id');
        return Note.fromJson(res.data!);
      });

  @override
  Future<Note> create(NoteDraft draft) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/notes',
      data: draft.toJson(),
    );
    return Note.fromJson(res.data!);
  }

  @override
  Future<Note> update(String id, NoteDraft draft) => _notFoundAs(id, () async {
        final res = await _dio.put<Map<String, dynamic>>(
          '/notes/$id',
          data: draft.toJson(),
        );
        return Note.fromJson(res.data!);
      });

  @override
  Future<void> delete(String id) =>
      _notFoundAs(id, () => _dio.delete<void>('/notes/$id'));

  Future<T> _notFoundAs<T>(String id, Future<T> Function() body) async {
    try {
      return await body();
    } on DioException catch (e) {
      final api = ApiException.fromDio(e);
      if (api.kind == ApiErrorKind.notFound) throw NoteNotFoundException(id);
      throw api;
    }
  }
}
