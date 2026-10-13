import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../logging/app_logger.dart';

/// Verifikasi pemilik perangkat (biometrik atau PIN/pola) di balik satu
/// kontrak agar fitur dan test tidak bergantung pada `local_auth`.
abstract interface class DeviceAuthenticator {
  Future<bool> isAvailable();
  Future<bool> authenticate(String reason);
}

class LocalAuthAuthenticator implements DeviceAuthenticator {
  LocalAuthAuthenticator([LocalAuthentication? auth])
    : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;
  final _log = log('device_auth');

  @override
  Future<bool> isAvailable() async {
    try {
      return await _auth.isDeviceSupported();
    } on PlatformException catch (e) {
      _log.warning('isDeviceSupported gagal', e);
      return false;
    }
  }

  @override
  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(localizedReason: reason);
    } on PlatformException catch (e) {
      _log.warning('authenticate gagal', e);
      return false;
    }
  }
}

/// Untuk test: hasil ditentukan lewat [available] dan [result].
class MemoryAuthenticator implements DeviceAuthenticator {
  MemoryAuthenticator({this.available = true, this.result = true});

  bool available;
  bool result;
  var attempts = 0;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<bool> authenticate(String reason) async {
    attempts++;
    return result;
  }
}

final deviceAuthenticatorProvider = Provider<DeviceAuthenticator>(
  (_) => LocalAuthAuthenticator(),
);
