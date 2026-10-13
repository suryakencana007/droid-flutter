/// Tipe hasil sederhana untuk operasi yang bisa gagal tanpa melempar exception.
sealed class Result<T> {
  const Result();

  const factory Result.ok(T value) = Ok<T>;
  const factory Result.err(Object error, [StackTrace? stackTrace]) = Err<T>;

  R when<R>({
    required R Function(T value) ok,
    required R Function(Object error, StackTrace? stackTrace) err,
  }) => switch (this) {
    Ok(:final value) => ok(value),
    Err(:final error, :final stackTrace) => err(error, stackTrace),
  };
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.error, [this.stackTrace]);
  final Object error;
  final StackTrace? stackTrace;
}

/// Jalankan [body] dan bungkus hasilnya ke dalam [Result].
Future<Result<T>> guard<T>(Future<T> Function() body) async {
  try {
    return Result.ok(await body());
  } catch (error, stackTrace) {
    return Result.err(error, stackTrace);
  }
}
