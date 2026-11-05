import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'books_screen.dart';
import 'cart_screen.dart';
import 'models/cart.dart';

void main() {
  // TASK 31: SHARE ONE CART WITH THE WHOLE APP
  runApp(ChangeNotifierProvider(create: (_) => Cart(), child: const Shell()));
}

// TASK 32: DEFINE THE APP AND ITS TWO ROUTES
class Shell extends StatelessWidget {
  const Shell({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),

      // TASK 33: OPEN BOOKSTORE OR CART
      routes: {
        '/': (_) => const BooksScreen(),
        '/cart': (_) => const CartScreen(),
      },
    );
  }
}
