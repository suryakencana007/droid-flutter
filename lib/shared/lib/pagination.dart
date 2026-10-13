/// Satu halaman hasil daftar berhalaman.
class Paginated<T> {
  const Paginated({
    required this.items,
    required this.page,
    required this.hasMore,
  });

  const Paginated.empty() : this(items: const [], page: 0, hasMore: false);

  final List<T> items;
  final int page;
  final bool hasMore;

  /// Gabungkan halaman berikutnya ke daftar yang ada.
  Paginated<T> append(Paginated<T> next) => Paginated(
    items: [...items, ...next.items],
    page: next.page,
    hasMore: next.hasMore,
  );

  Paginated<T> copyWith({List<T>? items, int? page, bool? hasMore}) =>
      Paginated(
        items: items ?? this.items,
        page: page ?? this.page,
        hasMore: hasMore ?? this.hasMore,
      );
}
