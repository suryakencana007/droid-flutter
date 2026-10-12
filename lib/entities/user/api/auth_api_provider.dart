import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_api.dart';
import 'fake_auth_api.dart';

/// Ganti implementasi di sini (atau override di `main.dart`) untuk backend
/// sungguhan, misalnya `DioAuthApi(ref.watch(dioProvider))`.
final authApiProvider = Provider<AuthApi>((ref) => FakeAuthApi());
