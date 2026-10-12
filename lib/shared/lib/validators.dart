typedef Validator = String? Function(String? value);

/// Validator untuk `FTextFormField.validator`. Gabungkan dengan [compose].
abstract final class Validators {
  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  static Validator required({String message = 'Wajib diisi'}) =>
      (value) => (value == null || value.trim().isEmpty) ? message : null;

  static Validator email({String message = 'Format email tidak valid'}) =>
      (value) {
        if (value == null || value.isEmpty) return null;
        return _emailPattern.hasMatch(value.trim()) ? null : message;
      };

  static Validator minLength(int length, {String? message}) => (value) {
        if (value == null || value.isEmpty) return null;
        return value.length >= length
            ? null
            : message ?? 'Minimal $length karakter';
      };

  /// [other] dibaca saat validasi supaya selalu dapat nilai terbaru.
  static Validator match(
    String Function() other, {
    String message = 'Tidak sama',
  }) =>
      (value) => value == other() ? null : message;

  static Validator compose(List<Validator> validators) => (value) {
        for (final validator in validators) {
          final error = validator(value);
          if (error != null) return error;
        }
        return null;
      };
}
