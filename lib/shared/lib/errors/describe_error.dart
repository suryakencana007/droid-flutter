import '../../l10n/index.dart';

/// Pesan yang aman ditampilkan ke user untuk error dari layer shared.
/// Entity menambahkan pemetaannya sendiri (lihat `describeAuthError`).
String describeError(Object error, AppLocalizations l10n) => switch (error) {
      final DescribableError e => e.describe(l10n),
      _ => l10n.errorGeneric,
    };

/// Error yang bisa menjelaskan dirinya dalam bahasa user.
abstract interface class DescribableError {
  String describe(AppLocalizations l10n);
}
