import 'package:flutter/foundation.dart';

/// Listenable kecil yang dipicu provider agar go_router mengevaluasi ulang
/// `redirect`.
class RouterRefresh extends ChangeNotifier {
  void refresh() => notifyListeners();
}
