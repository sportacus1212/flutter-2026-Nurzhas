import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_badge.dart';
import 'models/book.dart';
import 'models/cart.dart';

// TASK 67: CREATE THE BOOKSTORE WITH SEARCH
class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  // TASK 68: STORE THE SEARCH TEXT LOCALLY
  String _searchText = '';

  // TASK 69: FILTER BOOKS BY TITLE OR AUTHOR
  List<Book> get filteredBooks {
    final query = _searchText.trim().toLowerCase();

    return books.where((book) {
      return book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('BooksScreen build');

    final visibleBooks = filteredBooks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),

        // TASK 70: DISPLAY THE SHOPPING CART BADGE
        actions: const [CartBadge()],

        // TASK 71: ADD THE SEARCH FIELD
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(68),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search books...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),

              // TASK 72: UPDATE SEARCH RESULTS WHILE TYPING
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
        ),
      ),

      // TASK 73: DISPLAY THE FILTERED BOOK LIST
      body: visibleBooks.isEmpty
          ? const Center(child: Text('No books found'))
          : ListView.builder(
              itemCount: visibleBooks.length,
              itemBuilder: (context, index) {
                final book = visibleBooks[index];

                // TASK 74: DETECT WHETHER THE BOOK IS SELECTED
                final added = context.watch<Cart>().items.contains(book);

                debugPrint('row ${book.title}');

                return ListTile(
                  title: Text(book.title),
                  subtitle: Text('${book.author}\n${book.price} ₸'),
                  isThreeLine: true,

                  // TASK 75: SWITCH BETWEEN ADD AND ADDED
                  trailing: added
                      ? const Text(
                          'Added',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : OutlinedButton(
                          onPressed: () {
                            // TASK 76: ADD THROUGH THE SHARED MANAGER
                            final ok = context.read<Cart>().add(book);

                            // TASK 77: SHOW SUCCESS ONLY WHEN ADDED
                            if (ok) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Added: ${book.title}'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          child: const Text('Add'),
                        ),
                );
              },
            ),
    );
  }
}
