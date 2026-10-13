import 'package:droid/entities/note/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteNoteController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> delete(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(noteApiProvider).delete(id);
      ref.read(notesProvider.notifier).remove(id);
    });
    return !state.hasError;
  }
}

final deleteNoteControllerProvider =
    AsyncNotifierProvider<DeleteNoteController, void>(DeleteNoteController.new);
