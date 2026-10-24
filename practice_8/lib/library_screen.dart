import 'package:flutter/material.dart';
import 'add_book_screen.dart';
import 'detail_screen.dart';
import 'models/book.dart';
import 'widgets/book_tile.dart';

enum Filter { all, unread, read }

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final List<Book> _books = [...seed];
  Filter _filter = Filter.all;

  // Level 2: Switch expression for visible book filtering
  List<Book> get _visible {
    return switch (_filter) {
      Filter.all => _books,
      Filter.unread => unread(_books),
      Filter.read => _books.where((b) => b.read).toList(),
    };
  }

  void _openDetail(Book book) async {
    final action = await Navigator.push<BookAction>(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(book: book)),
    );

    if (!mounted || action == null) return;

    setState(() {
      switch (action) {
        case BookAction.toggleRead:
          book.read = !book.read;
        case BookAction.delete:
          _books.remove(book);
      }
    });
  }

  void _addBook() async {
    final newBook = await Navigator.push<Book>(
      context,
      MaterialPageRoute(builder: (_) => const AddBookScreen()),
    );

    if (newBook != null && mounted) {
      setState(() {
        _books.add(newBook);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visibleList = _visible;

    return Scaffold(
      appBar: AppBar(
        title: Text('Reading list (${visibleList.length})'),
      ),
      body: Column(
        children: [
          // Level 3: Header statistics card
          Card(
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${_books.length}',
                          style: theme.textTheme.headlineSmall,
                        ),
                        Text('Books', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${totalPages(_books)}',
                          style: theme.textTheme.headlineSmall,
                        ),
                        Text('Pages', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${unread(_books).length}',
                          style: theme.textTheme.headlineSmall,
                        ),
                        Text('Unread', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Filter ChoiceChips
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: Filter.values.map((f) {
              final label = f.name[0].toUpperCase() + f.name.substring(1);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  label: Text(label),
                  selected: _filter == f,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _filter = f;
                      });
                    }
                  },
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: visibleList.length,
              itemBuilder: (context, index) {
                final book = visibleList[index];
                return BookTile(
                  book: book,
                  onTap: () => _openDetail(book),
                  onToggle: () {
                    setState(() {
                      book.read = !book.read;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
        child: const Icon(Icons.add),
      ),
    );
  }
}