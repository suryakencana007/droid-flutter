import 'package:droid/shared/api/index.dart';
import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cached_note_api.dart';
import 'dio_note_api.dart';
import 'fake_note_api.dart';
import 'note_api.dart';

/// Sumber jaringan (Fake di dev, Dio selainnya).
final remoteNoteApiProvider = Provider<NoteApi>(
  (ref) => Env.useFakeApi ? FakeNoteApi() : DioNoteApi(ref.watch(dioProvider)),
);

/// Yang dipakai feature: jaringan + cache drift + antrian offline.
final noteApiProvider = Provider<NoteApi>(
  (ref) => CachedNoteApi(
    remote: ref.watch(remoteNoteApiProvider),
    db: ref.watch(appDatabaseProvider),
    isOnline: () => ref.read(isOnlineProvider).value ?? true,
  ),
);
