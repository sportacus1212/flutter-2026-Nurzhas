# Practice 9 — Put It High, Subscribe Low

## Level 1 — Lift It Up

The first implementation stored the selected books in
Shell above MaterialApp.

The BooksScreen received the cart and Add callback.
The CartScreen received the cart and Remove callback.

### Passing the total through constructors

Constructors modified: 2
Files: books_screen.dart and cart_badge.dart

The total was calculated in Shell and passed through
BooksScreen to CartBadge.

### Rebuild experiment

BooksScreen build count: TO BE MEASURED
Book row build count: TO BE MEASURED

The initial implementation used setState in Shell.
A cart change could rebuild more of the interface
than necessary.

## Level 2 — Separate Model

Book information was moved to models/book.dart.
The Cart class was created in models/cart.dart.

The cart prevents duplicate entries.
The items collection is unmodifiable from outside.
The model calculates the count, quantity, and total.

The model does not contain screen navigation,
popups, colors, or widget code.

## Level 3 — Provider

Provider shares one Cart object with both screens.

watch subscribes to changes.
read accesses the object without subscribing.
Consumer rebuilds its section when the cart changes.

### Incorrect watch experiment

Actual error text: TO BE RECORDED

Using watch inside an event callback is incorrect.
The callback should use read.

### Incorrect read experiment

Actual observation: TO BE RECORDED

Using read for a changing display does not subscribe
that display to updates. The number can become stale.

## Level 4 — Rebuild Optimization

The cart now stores a quantity for each distinct book.

The badge displays the number of distinct books,
not the sum of all quantities.

### With watch

Badge rebuilds after 3 quantity increases:
TO BE MEASURED

### With select

Badge rebuilds after 3 quantity increases:
TO BE MEASURED

### Explanation

watch subscribes to the Cart object.
It reacts to notifications even if count is unchanged.

select listens to the selected count.
It avoids rebuilding the badge when the count
has not changed.

The total price uses a separate subscription,
so changing quantities still updates the price.

Consumer uses a constant child for the Total label.
That child does not need to be rebuilt each time
the cart total changes.

### Broad subscription experiment

Actual row rebuild observations: TO BE RECORDED

Subscribing in a larger widget can unnecessarily
rebuild parts that do not display the changed value.

## Level 5 — Where Does It Live?

### Cart

Home: provided

Reason: Several screens need the same cart
information, including its contents and total.

### Search text

Home: ephemeral

Reason: The search text is needed only by
the Books screen. Other screens do not need it.

### Expanded or collapsed total

Home: ephemeral

Reason: This only controls how one screen displays
the total. It is temporary screen information.

### Theme mode

Home: provided

Reason: A dark-mode setting would affect the
appearance of the entire application and would
need to be shared across multiple screens.

## Final Verification

- Cart uses a private map.
- Book quantities are supported.
- Badge uses select.
- Cart list uses Consumer.
- Total uses Consumer with a constant child.
- Added notifications appear only after success.
- Clear cart requires confirmation.
- Search filters the bookstore.
- Cart model contains no screen UI logic.

## Commands

dart format .
flutter analyze
flutter test

## Screenshots

screenshot_books.png
screenshot_cart.png
