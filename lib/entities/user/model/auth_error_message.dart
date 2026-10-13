import 'package:droid/shared/l10n/index.dart';

import '../api/auth_api.dart';

/// Pesan untuk user dari error [AuthApi], dalam bahasa aktif.
String describeAuthError(Object error, AppLocalizations l10n) => switch (error) {
      AuthException(code: 'invalid-credentials') => l10n.authInvalidCredentials,
      AuthException(code: 'email-in-use') => l10n.authEmailInUse,
      AuthException(:final message) => message,
      _ => l10n.errorGeneric,
    };
