/// Pesan umum yang aman ditampilkan ke user untuk error dari layer shared.
/// Entity menambahkan pemetaannya sendiri (lihat `describeAuthError`).
String describeError(Object error) => switch (error) {
      final DescribableError e => e.userMessage,
      _ => 'Terjadi kesalahan. Coba lagi.',
    };

/// Error yang sudah membawa pesan untuk user.
abstract interface class DescribableError {
  String get userMessage;
}
