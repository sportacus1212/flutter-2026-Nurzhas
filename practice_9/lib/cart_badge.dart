import 'package:flutter/material.dart';

// TASK 12: CREATE THE SHOPPING CART BADGE
class CartBadge extends StatelessWidget {
  const CartBadge({super.key, required this.count, required this.total});

  final int count;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$total ₸'),

        // TASK 13: SHOW SELECTED BOOK COUNT
        Badge(
          label: Text('$count'),
          child: IconButton(
            icon: const Icon(Icons.shopping_cart),

            // TASK 14: OPEN THE CART SCREEN
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
