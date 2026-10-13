import 'package:droid/entities/note/index.dart';
import 'package:droid/shared/api/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:flutter_test/flutter_test.dart';

/// Remote yang bisa "diputus": saat [online] false melempar error jaringan.
class _FlakyRemote implements NoteApi {
  _FlakyRemote(this.inner);
  final FakeNoteApi inner;
  bool online = true;

  Future<T> _call<T>(Future<T> Function() body) {
    if (!online) throw const ApiException(ApiErrorKind.network);
    return body();
  }

  @override
  Future<Paginated<Note>> list({int page = 1, int pageSize = 20}) =>
      _call(() => inner.list(page: page, pageSize: pageSize));
  @override
  Future<Note> get(String id) => _call(() => inner.get(id));
  @override
  Future<Note> create(NoteDraft draft) => _call(() => inner.create(draft));
  @override
  Future<Note> update(String id, NoteDraft draft) =>
      _call(() => inner.update(id, draft));
  @override
  Future<void> delete(String id) => _call(() => inner.delete(id));
}

void main() {
  late AppDatabase db;
  late _FlakyRemote remote;
  late CachedNoteApi api;
  var online = true;

  setUp(() {
    db = AppDatabase.memory();
    remote = _FlakyRemote(FakeNoteApi(latency: Duration.zero, seedCount: 5));
    online = true;
    api = CachedNoteApi(remote: remote, db: db, isOnline: () => online);
  });

  tearDown(() => db.close());

  test(
    'online: daftar dari jaringan tersimpan ke cache dan terbaca offline',
    () async {
      final first = await api.list(pageSize: 3);
      expect(first.items, hasLength(3));
      expect(first.hasMore, isTrue);

      online = false;
      remote.online = false;
      final cached = await api.list(pageSize: 3);
      expect(cached.items.map((n) => n.id), first.items.map((n) => n.id));
      expect(cached.hasMore, isFalse); // hanya 3 yang pernah di-cache
      expect((await api.get(first.items.first.id)).id, first.items.first.id);
    },
  );

  test('jaringan gagal walau dianggap online: jatuh ke cache', () async {
    await api.list();
    remote.online = false; // online() masih true, tapi request gagal
    final cached = await api.list();
    expect(cached.items, hasLength(5));
  });

  test(
    'offline: buat/ubah/hapus masuk antrian lalu tersinkron saat online',
    () async {
      await api.list();
      online = false;
      remote.online = false;

      final created = await api.create(
        const NoteDraft(title: 'Offline', body: 'dibuat tanpa jaringan'),
      );
      expect(created.id, startsWith('local-'));
      expect((await api.list()).items.first.id, created.id);

      final updated = await api.update(
        created.id,
        const NoteDraft(title: 'Offline v2', body: 'diperbarui'),
      );
      expect(updated.title, 'Offline v2');
      await api.delete('1'); // catatan server dihapus saat offline
      expect(
        await api.watchPendingCount().first,
        2,
      ); // create (digabung) + delete

      online = true;
      remote.online = true;
      final done = await api.sync();
      expect(done, 2);
      expect(await api.watchPendingCount().first, 0);

      final serverList = await remote.inner.list(pageSize: 50);
      expect(serverList.items.any((n) => n.title == 'Offline v2'), isTrue);
      expect(serverList.items.any((n) => n.id == '1'), isFalse);
      final refreshed = await api.list(pageSize: 50);
      expect(refreshed.items.any((n) => n.id.startsWith('local-')), isFalse);
    },
  );

  test(
    'hapus catatan lokal yang belum tersinkron membatalkan antriannya',
    () async {
      online = false;
      remote.online = false;
      final created = await api.create(const NoteDraft(title: 'x', body: 'y'));
      await api.delete(created.id);
      expect(await api.watchPendingCount().first, 0);
      expect(() => api.get(created.id), throwsA(isA<NoteNotFoundException>()));
    },
  );
}
