import 'package:flutter/foundation.dart';

import 'book.dart';

// TASK 50: MANAGE CART DATA SEPARATELY FROM SCREENS
class Cart extends ChangeNotifier {
  // TASK 51: STORE EACH BOOK AND ITS QUANTITY
  final Map<Book, int> _qty = {};

  // TASK 52: PROTECT THE LIST OF SELECTED BOOKS
  List<Book> get items => List.unmodifiable(_qty.keys);

  // TASK 53: COUNT DIFFERENT BOOKS
  int get count => _qty.length;

  // TASK 54: GET THE QUANTITY OF A BOOK
  int qtyOf(Book book) {
    return _qty[book] ?? 0;
  }

  // TASK 55: CALCULATE THE TOTAL USING QUANTITIES
  int get total {
    int sum = 0;

    for (final book in _qty.keys) {
      sum += book.price * _qty[book]!;
    }

    return sum;
  }

  // TASK 56: ADD A BOOK ONLY IF IT IS NOT ALREADY ADDED
  bool add(Book book) {
    if (_qty.containsKey(book)) {
      return false;
    }

    _qty[book] = 1;
    notifyListeners();
    return true;
  }

  // TASK 57: INCREASE THE BOOK QUANTITY
  void increment(Book book) {
    if (!_qty.containsKey(book)) {
      return;
    }

    _qty[book] = _qty[book]! + 1;
    notifyListeners();
  }

  // TASK 58: REMOVE A BOOK COMPLETELY
  void remove(Book book) {
    _qty.remove(book);
    notifyListeners();
  }

  // TASK 59: CLEAR ALL SELECTED BOOKS
  void clear() {
    _qty.clear();
    notifyListeners();
  }
}
