import 'data.dart';
import 'models.dart';
import 'catalogue.dart';
import 'shelf_state.dart';

void main() {
  final library = Library();
  library.open();

  for (final raw in rawBooks) {
    library.add(Book.fromJson(raw));
  }

  library.add(const Magazine(
    title: 'Flutter Monthly',
    year: 2024,
    issue: 12,
  ));
  library.add(const Ghost(
    title: 'Haunted Code',
    year: 1999,
  ));

  print('=== LEVEL 3 & 4: CATALOGUE REPORT & QUERIES ===');
  print('Opened at: ${library.openedAt}');
  print('All titles: ${library.allTitles.toList()}');
  print('Books published after 2010: ${library.booksAfter2010.map((b) => b.title).toList()}');
  print('Average page count: ${library.averagePageCount.toStringAsFixed(1)}');
  print('Book count by author: ${library.bookCountByAuthor}');
  print('Distinct authors: ${library.distinctAuthors}');
  print('Present genres: ${library.presentGenres.map((g) => g.label).toList()}');

  print('\n=== COUNTRY LOOKUPS ===');
  print('Country of "Clean Code": ${library.countryOf('Clean Code')}');
  print('Country of "Design Patterns": ${library.countryOf('Design Patterns')}');
  print('Country of "Nonexistent": ${library.countryOf('Nonexistent')}');

  print('\n=== DISPLAY LIST LITERAL ===');
  for (final line in library.displayList) {
    print('  $line');
  }

  print('\n=== LEVEL 5: DART 3 FEATURES ===');
  final booksOnly = library.items.whereType<Book>().toList();
  final stats = statsOf(booksOnly);
  print('Stats Record: Count = ${stats.count}, Avg Pages = ${stats.avgPages.toStringAsFixed(1)}');

  print('\n=== SHELF STATES ===');
  print(describe(Empty()));
  print(describe(Ready(booksOnly)));
  print(describe(Broken('Shelf collapsed under too many books')));
}