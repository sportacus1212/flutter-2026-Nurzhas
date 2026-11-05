import 'package:flutter/material.dart';

import 'books_screen.dart';
import 'cart_screen.dart';

// TASK 01: CREATE THE BOOK DATA
class Book {
  const Book({required this.title, required this.author, required this.price});

  final String title;
  final String author;
  final int price;
}

// TASK 02: CREATE THE SIX BOOKS
const books = [
  Book(
    title: 'Widgets All the Way Down',
    author: 'A. Nurmagambetova',
    price: 4200,
  ),
  Book(title: 'Null Safety for Humans', author: 'B. Seitkali', price: 3100),
  Book(
    title: 'Constraints Go Down, Sizes Go Up',
    author: 'C. Tashimova',
    price: 5600,
  ),
  Book(title: 'The Navigator Is a Stack', author: 'D. Alibekov', price: 2900),
  Book(
    title: 'Forms That Validate Themselves',
    author: 'E. Omarova',
    price: 3800,
  ),
  Book(
    title: 'Put It High, Subscribe Low',
    author: 'F. Kairatuly',
    price: 4700,
  ),
];

void main() {
  runApp(const Shell());
}

// TASK 03: KEEP ONE SHARED SHOPPING CART
class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  final List<Book> _cart = [];

  // TASK 04: ADD A BOOK
  void _add(Book book) {
    if (_cart.contains(book)) return;

    setState(() {
      _cart.add(book);
    });
  }

  // TASK 05: REMOVE A BOOK
  void _remove(Book book) {
    setState(() {
      _cart.remove(book);
    });
  }

  // TASK 06: CALCULATE THE TOTAL PRICE
  int get total {
    return _cart.fold(0, (sum, book) => sum + book.price);
  }

  // TASK 07: CONNECT BOTH SCREENS
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      routes: {
        '/': (_) => BooksScreen(cart: _cart, onAdd: _add, total: total),
        '/cart': (_) => CartScreen(items: _cart, onRemove: _remove),
      },
    );
  }
}
