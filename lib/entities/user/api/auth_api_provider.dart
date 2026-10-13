import 'package:droid/shared/api/index.dart';
import 'package:droid/shared/config/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_api.dart';
import 'dio_auth_api.dart';
import 'fake_auth_api.dart';

/// `env/<flavor>.json` → `USE_FAKE_API` memilih implementasi. Override di
/// test atau `main.dart` bila perlu backend lain (Supabase, Firebase, dst).
final authApiProvider = Provider<AuthApi>(
  (ref) => Env.useFakeApi ? FakeAuthApi() : DioAuthApi(ref.watch(dioProvider)),
);
