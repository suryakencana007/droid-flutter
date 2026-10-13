import 'package:droid/entities/note/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateNoteController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Mengembalikan catatan baru, atau `null` bila gagal (error di [state]).
  Future<Note?> submit(NoteDraft draft) async {
    state = const AsyncLoading();
    Note? created;
    state = await AsyncValue.guard(() async {
      created = await ref.read(noteApiProvider).create(draft);
      ref.read(notesProvider.notifier).upsert(created!);
      await ref.read(analyticsProvider).logEvent('note_create');
    });
    return state.hasError ? null : created;
  }
}

final createNoteControllerProvider =
    AsyncNotifierProvider<CreateNoteController, void>(CreateNoteController.new);
