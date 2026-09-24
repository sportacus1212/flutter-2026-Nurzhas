class Author {
  final String name;
  final String? country;

  const Author({
    required this.name,
    this.country,
  });

  @override
  String toString() => 'Author(name: $name, country: ${country ?? "unknown"})';
}

enum Genre {
  craft('Software Craftsmanship'),
  theory('Software Theory'),
  unknown('Unknown Genre');

  final String label;
  const Genre(this.label);

  static Genre fromString(String? raw) {
    return switch (raw?.toLowerCase()) {
      'craft' => Genre.craft,
      'theory' => Genre.theory,
      _ => Genre.unknown,
    };
  }
}

abstract class LibraryItem {
  final String title;
  final int year;

  const LibraryItem({
    required this.title,
    required this.year,
  });

  String describe();

  bool get isOld => (DateTime.now().year - year) > 20;
}

mixin Borrowable on LibraryItem {
  String borrowLabel() => 'Borrowed: $title';
}

class Book extends LibraryItem with Borrowable {
  final int pages;
  final Author author;
  final Genre genre;
  final String? description;

  const Book({
    required super.title,
    required super.year,
    required this.pages,
    required this.author,
    required this.genre,
    this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final rawTitle = json['title'] as String? ?? 'Untitled';
    final rawYear = json['year'] as int? ?? 0;
    final rawPages = json['pages'] as int? ?? 0;
    final rawAuthorName = json['author'] as String? ?? 'Unknown Author';
    final rawCountry = json['country'] as String?;
    final rawGenre = json['genre'] as String?;
    final rawDesc = json['description'] as String?;

    return Book(
      title: rawTitle,
      year: rawYear,
      pages: rawPages,
      author: Author(name: rawAuthorName, country: rawCountry),
      genre: Genre.fromString(rawGenre),
      description: rawDesc,
    );
  }

  bool get isLong => pages > 400;

  Book copyWith({
    String? title,
    int? year,
    int? pages,
    Author? author,
    Genre? genre,
    String? description,
  }) {
    return Book(
      title: title ?? this.title,
      year: year ?? this.year,
      pages: pages ?? this.pages,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      description: description ?? this.description,
    );
  }

  @override
  String describe() =>
      'Book "$title" ($year) - $pages pages, Genre: ${genre.label}';

  @override
  String toString() =>
      'Book(title: $title, year: $year, pages: $pages, author: $author, genre: $genre, description: $description)';
}

class Magazine extends LibraryItem {
  final int issue;

  const Magazine({
    required super.title,
    required super.year,
    required this.issue,
  });

  @override
  String describe() => 'Magazine "$title" ($year) - Issue #$issue';
}

class Ghost implements LibraryItem {
  @override
  final String title;

  @override
  final int year;

  const Ghost({
    required this.title,
    required this.year,
  });

  @override
  String describe() => 'Ghost item "$title" ($year)';

  @override
  bool get isOld => (DateTime.now().year - year) > 20;
}