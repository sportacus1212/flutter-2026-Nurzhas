import 'package:flutter/material.dart';

import 'main.dart';

// TASK 15: CREATE THE CART SCREEN
class CartScreen extends StatelessWidget {
  const CartScreen({super.key, required this.items, required this.onRemove});

  final List<Book> items;
  final void Function(Book) onRemove;

  @override
  Widget build(BuildContext context) {
    final total = items.fold(0, (sum, book) => sum + book.price);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: Column(
        children: [
          // TASK 16: DISPLAY SELECTED BOOKS
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final book = items[index];

                return ListTile(
                  title: Text(book.title),
                  subtitle: Text('${book.price} ₸'),

                  // TASK 17: REMOVE BOOK BUTTON
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => onRemove(book),
                  ),
                );
              },
            ),
          ),

          // TASK 18: DISPLAY CART TOTAL
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Total: $total ₸',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
