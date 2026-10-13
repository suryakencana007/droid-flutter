/// Lokalisasi app. String ada di `arb/app_id.arb` (template) dan
/// `arb/app_en.arb`; kelas dibuat oleh `flutter gen-l10n` (`just l10n`).
library;

import 'package:flutter/widgets.dart';

import 'generated/app_localizations.dart';

export 'generated/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Locale yang didukung app, dipakai pemilih bahasa.
abstract final class AppLocales {
  static const id = Locale('id');
  static const en = Locale('en');
}
