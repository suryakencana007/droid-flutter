typedef Validator = String? Function(String? value);

/// Validator untuk `FTextFormField.validator`. Pesan datang dari pemanggil
/// (biasanya `context.l10n.*`) agar terlokalisasi. Gabungkan dengan [compose].
abstract final class Validators {
  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  static Validator required(String message) =>
      (value) => (value == null || value.trim().isEmpty) ? message : null;

  static Validator email(String message) => (value) {
        if (value == null || value.isEmpty) return null;
        return _emailPattern.hasMatch(value.trim()) ? null : message;
      };

  static Validator minLength(int length, String message) => (value) {
        if (value == null || value.isEmpty) return null;
        return value.length >= length ? null : message;
      };

  /// [other] dibaca saat validasi supaya selalu dapat nilai terbaru.
  static Validator match(String Function() other, String message) =>
      (value) => value == other() ? null : message;

  static Validator compose(List<Validator> validators) => (value) {
        for (final validator in validators) {
          final error = validator(value);
          if (error != null) return error;
        }
        return null;
      };
}
