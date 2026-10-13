import 'package:droid/shared/api/index.dart';
import 'package:droid/shared/config/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dio_note_api.dart';
import 'fake_note_api.dart';
import 'note_api.dart';

final noteApiProvider = Provider<NoteApi>(
  (ref) => Env.useFakeApi ? FakeNoteApi() : DioNoteApi(ref.watch(dioProvider)),
);
