import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Penghitung respons 401 di luar endpoint auth. Entity user mendengarkan
/// provider ini untuk membersihkan sesi; `shared` sendiri tidak tahu apa
/// itu sesi.
class SessionExpiredNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void bump() => state++;
}

final sessionExpiredProvider =
    NotifierProvider<SessionExpiredNotifier, int>(SessionExpiredNotifier.new);
