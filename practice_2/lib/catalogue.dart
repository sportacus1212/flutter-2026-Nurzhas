import 'models.dart';

class Library {
  final List<LibraryItem> _items = [];

  List<LibraryItem> get items => List.unmodifiable(_items);

  void add(LibraryItem item) {
    _items.add(item);
  }

  Book? findByTitle(String title) {
    for (final item in _items) {
      if (item is Book && item.title == title) {
        return item;
      }
    }
    return null;
  }

  String countryOf(String title) {
    final book = findByTitle(title);
    return book?.author.country ?? 'unknown';
  }

  late final DateTime openedAt;

  void open() {
    openedAt = DateTime.now();
  }

  String? _cachedReport;

  String buildReport() {
    _cachedReport ??=
        'Library Report generated at $openedAt with ${_items.length} items.';
    return _cachedReport!;
  }

  List<Book> get _books => _items.whereType<Book>().toList();

  Iterable<String> get allTitles => _items.map((item) => item.title);

  List<Book> get booksAfter2010 =>
      _books.where((book) => book.year > 2010).toList();

  // Note: fold is used instead of reduce to handle empty lists safely and provide an initial accumulator.
  double get averagePageCount {
    if (_books.isEmpty) return 0.0;
    final totalPages = _books.fold<int>(0, (sum, book) => sum + book.pages);
    return totalPages / _books.length;
  }

  Map<String, int> get bookCountByAuthor {
    final map = <String, int>{};
    for (final book in _books) {
      final name = book.author.name;
      map[name] = (map[name] ?? 0) + 1;
    }
    return map;
  }

  Set<String> get distinctAuthors =>
      _books.map((book) => book.author.name).toSet();

  Set<Genre> get presentGenres => _books.map((book) => book.genre).toSet();

  List<String> get displayList => [
        'CATALOGUE',
        for (final book in _books) '${book.title} (${book.year})',
        ...distinctAuthors,
        if (_books.any((book) => book.pages == 0)) '(incomplete data)',
      ];
}