import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/lib/index.dart';

import '../api/auth_api.dart';

/// Pesan untuk user dari error [AuthApi], dalam bahasa aktif.
String describeAuthError(Object error, AppLocalizations l10n) => switch (error) {
      AuthException(code: 'invalid-credentials') => l10n.authInvalidCredentials,
      AuthException(code: 'email-in-use') => l10n.authEmailInUse,
      AuthException(cause: final DescribableError cause) => cause.describe(l10n),
      AuthException(:final message) => message,
      _ => describeError(error, l10n),
    };
