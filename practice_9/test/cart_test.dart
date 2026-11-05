import 'package:flutter_test/flutter_test.dart';

import 'package:practice_9/models/book.dart';
import 'package:practice_9/models/cart.dart';

void main() {
  // TASK 94: VERIFY ADD AND DUPLICATE PROTECTION
  test('Cart rejects duplicate books', () {
    final cart = Cart();

    expect(cart.add(books[0]), true);
    expect(cart.add(books[0]), false);
    expect(cart.count, 1);
    expect(cart.qtyOf(books[0]), 1);

    cart.dispose();
  });

  // TASK 95: VERIFY QUANTITY CHANGES
  test('Increment changes quantity but not book count', () {
    final cart = Cart();

    cart.add(books[0]);
    cart.add(books[1]);

    cart.increment(books[0]);
    cart.increment(books[0]);

    expect(cart.count, 2);
    expect(cart.qtyOf(books[0]), 3);
    expect(cart.qtyOf(books[1]), 1);

    // 4200 * 3 + 3100 = 15700
    expect(cart.total, 15700);

    cart.dispose();
  });

  // TASK 96: VERIFY REMOVAL AND CLEARING
  test('Remove and clear update the cart', () {
    final cart = Cart();

    cart.add(books[0]);
    cart.add(books[1]);

    cart.remove(books[0]);

    expect(cart.count, 1);
    expect(cart.total, 3100);

    cart.clear();

    expect(cart.count, 0);
    expect(cart.total, 0);

    cart.dispose();
  });

  // TASK 97: VERIFY THE ITEMS LIST IS PROTECTED
  test('Outside code cannot modify cart items', () {
    final cart = Cart();

    cart.add(books[0]);

    expect(() => cart.items.add(books[1]), throwsUnsupportedError);

    cart.dispose();
  });

  // TASK 98: VERIFY CHANGE NOTIFICATIONS
  test('Cart notifies listeners after changes', () {
    final cart = Cart();
    int notifications = 0;

    cart.addListener(() {
      notifications++;
    });

    cart.add(books[0]);
    cart.increment(books[0]);
    cart.remove(books[0]);
    cart.clear();

    expect(notifications, 4);

    cart.dispose();
  });
}
