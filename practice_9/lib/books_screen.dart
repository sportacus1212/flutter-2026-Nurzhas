import 'package:flutter/material.dart';

import 'main.dart';
import 'cart_badge.dart';

// TASK 08: CREATE THE BOOKSTORE SCREEN
class BooksScreen extends StatelessWidget {
  const BooksScreen({
    super.key,
    required this.cart,
    required this.onAdd,
    required this.total,
  });

  final List<Book> cart;
  final void Function(Book) onAdd;
  final int total;

  @override
  Widget build(BuildContext context) {
    debugPrint('BooksScreen build');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        actions: [
          // TASK 09: SHOW CART COUNT AND TOTAL
          CartBadge(count: cart.length, total: total),
        ],
      ),

      // TASK 10: DISPLAY ALL AVAILABLE BOOKS
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          final added = cart.contains(book);

          debugPrint('row ${book.title}');

          return ListTile(
            title: Text(book.title),
            subtitle: Text('${book.author}\n${book.price} ₸'),
            isThreeLine: true,

            // TASK 11: CHANGE ADD TO ADDED
            trailing: added
                ? const Text('Added')
                : OutlinedButton(
                    onPressed: () => onAdd(book),
                    child: const Text('Add'),
                  ),
          );
        },
      ),
    );
  }
}
