import 'package:droid/shared/lib/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/cached_note_api.dart';
import '../api/note_api_provider.dart';
import 'notes_provider.dart';

/// Jumlah perubahan catatan yang menunggu dikirim ke server.
final pendingNoteOpsProvider = StreamProvider<int>((ref) {
  final api = ref.watch(noteApiProvider);
  return api is CachedNoteApi ? api.watchPendingCount() : Stream.value(0);
});

/// Menjalankan sinkronisasi saat koneksi kembali, lalu memuat ulang daftar.
/// Di-watch sekali oleh halaman catatan (atau App) agar aktif.
final noteSyncProvider = Provider<Future<int> Function()>((ref) {
  Future<int> sync() async {
    final api = ref.read(noteApiProvider);
    if (api is! CachedNoteApi) return 0;
    final done = await api.sync();
    if (done > 0) await ref.read(notesProvider.notifier).refresh();
    return done;
  }

  ref.listen(isOnlineProvider, (previous, next) {
    if (next.value == true && previous?.value != true) sync();
  });
  return sync;
});
