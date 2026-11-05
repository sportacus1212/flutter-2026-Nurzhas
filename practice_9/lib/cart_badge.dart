import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';

// TASK 60: DISPLAY THE CART ICON AND ITS BADGE
class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    // TASK 61: TRACK HOW OFTEN THE BADGE REBUILDS
    debugPrint('badge build');

    // TASK 62: LISTEN ONLY TO THE NUMBER OF DIFFERENT BOOKS
    final count = context.select<Cart, int>((cart) => cart.count);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // TASK 63: UPDATE THE TOTAL PRICE INDEPENDENTLY
        const CartTotalPrice(),

        // TASK 64: DISPLAY THE SELECTED BOOK COUNT
        Badge(
          label: Text('$count'),
          child: IconButton(
            icon: const Icon(Icons.shopping_cart),

            // TASK 65: NAVIGATE TO THE CART SCREEN
            onPressed: () {
              Navigator.of(context).pushNamed('/cart');
            },
          ),
        ),

        const SizedBox(width: 12),
      ],
    );
  }
}

// TASK 66: LISTEN TO TOTAL PRICE CHANGES SEPARATELY
class CartTotalPrice extends StatelessWidget {
  const CartTotalPrice({super.key});

  @override
  Widget build(BuildContext context) {
    final total = context.select<Cart, int>((cart) => cart.total);

    return Text('$total ₸');
  }
}
