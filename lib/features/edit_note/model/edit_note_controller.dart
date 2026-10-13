import 'package:droid/entities/note/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditNoteController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<Note?> submit(String id, NoteDraft draft) async {
    state = const AsyncLoading();
    Note? updated;
    state = await AsyncValue.guard(() async {
      updated = await ref.read(noteApiProvider).update(id, draft);
      ref.read(notesProvider.notifier).upsert(updated!);
    });
    return state.hasError ? null : updated;
  }
}

final editNoteControllerProvider =
    AsyncNotifierProvider<EditNoteController, void>(EditNoteController.new);
