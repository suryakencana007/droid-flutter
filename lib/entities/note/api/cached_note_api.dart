import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:droid/shared/api/index.dart';
import 'package:droid/shared/lib/index.dart';

import '../model/note.dart';
import 'note_api.dart';

/// Membungkus [NoteApi] jaringan dengan cache drift dan antrian offline.
///
/// - Online: panggil jaringan, simpan hasilnya ke cache.
/// - Offline (menurut [isOnline] atau saat jaringan gagal): baca cache; buat,
///   ubah, dan hapus diterapkan ke cache dan dicatat di `pending_ops`.
/// - [sync] menjalankan antrian saat online; id lokal (`local-*`) diganti id
///   server setelah create berhasil.
class CachedNoteApi implements NoteApi {
  CachedNoteApi({
    required this._remote,
    required this._db,
    required this._isOnline,
  });

  static const entity = 'note';

  final NoteApi _remote;
  final AppDatabase _db;
  final bool Function() _isOnline;
  final _log = log('note_cache');

  bool _isLocal(String id) => id.startsWith('local-');

  // ---------- baca ----------

  @override
  Future<Paginated<Note>> list({int page = 1, int pageSize = 20}) async {
    if (_isOnline()) {
      try {
        final result = await _remote.list(page: page, pageSize: pageSize);
        await _cacheAll(result.items, clearFirst: page == 1);
        return result;
      } on ApiException catch (e) {
        if (!_isOffline(e)) rethrow;
        _log.info('list offline, pakai cache');
      }
    }
    return _listFromCache(page: page, pageSize: pageSize);
  }

  @override
  Future<Note> get(String id) async {
    if (_isOnline() && !_isLocal(id)) {
      try {
        final note = await _remote.get(id);
        await _upsert(note);
        return note;
      } on ApiException catch (e) {
        if (!_isOffline(e)) rethrow;
      }
    }
    final row = await (_db.select(
      _db.noteRows,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? throw NoteNotFoundException(id) : _fromRow(row);
  }

  // ---------- tulis ----------

  @override
  Future<Note> create(NoteDraft draft) async {
    if (_isOnline()) {
      try {
        final note = await _remote.create(draft);
        await _upsert(note);
        return note;
      } on ApiException catch (e) {
        if (!_isOffline(e)) rethrow;
      }
    }
    final now = DateTime.now();
    final note = Note(
      id: 'local-${now.microsecondsSinceEpoch}',
      title: draft.title.trim(),
      body: draft.body.trim(),
      createdAt: now,
      updatedAt: now,
    );
    await _upsert(note);
    await _enqueue('create', note.id, draft);
    return note;
  }

  @override
  Future<Note> update(String id, NoteDraft draft) async {
    if (_isOnline() && !_isLocal(id)) {
      try {
        final note = await _remote.update(id, draft);
        await _upsert(note);
        return note;
      } on ApiException catch (e) {
        if (!_isOffline(e)) rethrow;
      }
    }
    final existing = await get(id);
    final note = existing.copyWith(
      title: draft.title.trim(),
      body: draft.body.trim(),
      updatedAt: DateTime.now(),
    );
    await _upsert(note);
    if (_isLocal(id)) {
      // Catatan belum pernah sampai server: cukup perbarui payload create.
      await _replacePayload(id, draft);
    } else {
      await _enqueue('update', id, draft);
    }
    return note;
  }

  @override
  Future<void> delete(String id) async {
    if (_isOnline() && !_isLocal(id)) {
      try {
        await _remote.delete(id);
        await _removeRow(id);
        return;
      } on ApiException catch (e) {
        if (!_isOffline(e)) rethrow;
      }
    }
    await _removeRow(id);
    if (_isLocal(id)) {
      await (_db.delete(
        _db.pendingOps,
      )..where((t) => t.targetId.equals(id))).go();
    } else {
      await _enqueue('delete', id, null);
    }
  }

  // ---------- sinkronisasi ----------

  /// Jumlah perubahan yang menunggu, sebagai stream untuk UI.
  Stream<int> watchPendingCount() => (_db.select(
    _db.pendingOps,
  )..where((t) => t.entity.equals(entity))).watch().map((rows) => rows.length);

  /// Jalankan antrian berurutan. Berhenti di kegagalan jaringan pertama;
  /// operasi yang ditolak server (bukan masalah jaringan) dibuang agar tidak
  /// menyumbat antrian. Mengembalikan jumlah operasi yang berhasil.
  Future<int> sync() async {
    if (!_isOnline()) return 0;
    final ops =
        await (_db.select(_db.pendingOps)
              ..where((t) => t.entity.equals(entity))
              ..orderBy([(t) => OrderingTerm.asc(t.id)]))
            .get();
    var done = 0;
    for (final op in ops) {
      try {
        await _apply(op);
        await (_db.delete(
          _db.pendingOps,
        )..where((t) => t.id.equals(op.id))).go();
        done++;
      } on ApiException catch (e) {
        if (_isOffline(e)) break;
        _log.warning('op ${op.op} ${op.targetId} ditolak server, dibuang', e);
        await (_db.delete(
          _db.pendingOps,
        )..where((t) => t.id.equals(op.id))).go();
      } on NoteNotFoundException {
        await (_db.delete(
          _db.pendingOps,
        )..where((t) => t.id.equals(op.id))).go();
      }
    }
    return done;
  }

  Future<void> _apply(PendingOp op) async {
    final draft = op.payload == null
        ? null
        : NoteDraft.fromJson(jsonDecode(op.payload!) as Map<String, dynamic>);
    switch (op.op) {
      case 'create':
        final note = await _remote.create(draft!);
        await _db.transaction(() async {
          await _removeRow(op.targetId);
          await _upsert(note);
        });
      case 'update':
        await _upsert(await _remote.update(op.targetId, draft!));
      case 'delete':
        await _remote.delete(op.targetId);
    }
  }

  // ---------- helper ----------

  bool _isOffline(ApiException e) =>
      e.kind == ApiErrorKind.network || e.kind == ApiErrorKind.timeout;

  Future<Paginated<Note>> _listFromCache({
    required int page,
    required int pageSize,
  }) async {
    final rows =
        await (_db.select(_db.noteRows)
              ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
              ..limit(pageSize + 1, offset: (page - 1) * pageSize))
            .get();
    final hasMore = rows.length > pageSize;
    return Paginated(
      items: rows.take(pageSize).map(_fromRow).toList(),
      page: page,
      hasMore: hasMore,
    );
  }

  Future<void> _cacheAll(List<Note> notes, {required bool clearFirst}) =>
      _db.transaction(() async {
        if (clearFirst) {
          // Pertahankan catatan lokal yang belum tersinkron.
          await (_db.delete(
            _db.noteRows,
          )..where((t) => t.id.like('local-%').not())).go();
        }
        for (final note in notes) {
          await _upsert(note);
        }
      });

  Future<void> _upsert(Note note) => _db
      .into(_db.noteRows)
      .insertOnConflictUpdate(
        NoteRowsCompanion.insert(
          id: note.id,
          title: note.title,
          body: note.body,
          createdAt: note.createdAt,
          updatedAt: note.updatedAt,
        ),
      );

  Future<void> _removeRow(String id) =>
      (_db.delete(_db.noteRows)..where((t) => t.id.equals(id))).go();

  Future<void> _enqueue(String op, String targetId, NoteDraft? draft) => _db
      .into(_db.pendingOps)
      .insert(
        PendingOpsCompanion.insert(
          entity: entity,
          op: op,
          targetId: targetId,
          payload: Value(draft == null ? null : jsonEncode(draft.toJson())),
          createdAt: DateTime.now(),
        ),
      );

  Future<void> _replacePayload(String targetId, NoteDraft draft) =>
      (_db.update(
        _db.pendingOps,
      )..where((t) => t.targetId.equals(targetId))).write(
        PendingOpsCompanion(payload: Value(jsonEncode(draft.toJson()))),
      );

  Note _fromRow(NoteRow row) => Note(
    id: row.id,
    title: row.title,
    body: row.body,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}
