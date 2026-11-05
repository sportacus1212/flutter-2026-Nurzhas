import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';

// TASK 78: CREATE THE CART SCREEN
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // TASK 79: STORE WHETHER THE TOTAL SECTION IS EXPANDED
  bool _showTotal = true;

  // TASK 80: ASK BEFORE CLEARING THE CART
  Future<void> _confirmClear() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear cart?'),
          content: const Text('Are you sure you want to remove all books?'),
          actions: [
            // TASK 81: CANCEL WITHOUT DELETING BOOKS
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),

            // TASK 82: CONFIRM CLEARING THE CART
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );

    // TASK 83: CHECK THAT THE SCREEN STILL EXISTS
    if (!mounted) return;

    // TASK 84: CLEAR ONLY AFTER CONFIRMATION
    if (confirmed == true) {
      context.read<Cart>().clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),

        actions: [
          // TASK 85: SHOW CLEAR CART BUTTON
          IconButton(
            tooltip: 'Clear cart',
            icon: const Icon(Icons.delete_sweep),
            onPressed: _confirmClear,
          ),
        ],
      ),

      body: Column(
        children: [
          // TASK 86: AUTOMATICALLY UPDATE THE BOOK LIST
          Expanded(
            child: Consumer<Cart>(
              builder: (context, cart, _) {
                if (cart.items.isEmpty) {
                  return const Center(child: Text('Your cart is empty'));
                }

                return ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final book = cart.items[index];
                    final quantity = cart.qtyOf(book);

                    return ListTile(
                      title: Text(book.title),

                      // TASK 87: SHOW QUANTITY AND SUBTOTAL
                      subtitle: Text(
                        '${book.price} ₸ × $quantity = '
                        '${book.price * quantity} ₸',
                      ),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // TASK 88: INCREASE THE BOOK QUANTITY
                          IconButton(
                            tooltip: 'Increase quantity',
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              cart.increment(book);
                            },
                          ),

                          // TASK 89: REMOVE THE BOOK COMPLETELY
                          IconButton(
                            tooltip: 'Remove book',
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              cart.remove(book);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // TASK 90: EXPAND OR COLLAPSE THE TOTAL SECTION
          TextButton.icon(
            onPressed: () {
              setState(() {
                _showTotal = !_showTotal;
              });
            },
            icon: Icon(_showTotal ? Icons.expand_less : Icons.expand_more),
            label: Text(_showTotal ? 'Hide total' : 'Show total'),
          ),

          if (_showTotal)
            // TASK 91: UPDATE ONLY THE CHANGING TOTAL VALUE
            Consumer<Cart>(
              child: const TotalLabel(),
              builder: (context, cart, child) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // TASK 92: REUSE THE UNCHANGING LABEL
                      child!,

                      Text(
                        '${cart.total} ₸',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// TASK 93: KEEP THE TOTAL LABEL CONSTANT
class TotalLabel extends StatelessWidget {
  const TotalLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.payments_outlined),
        SizedBox(width: 8),
        Text(
          'Total:',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
