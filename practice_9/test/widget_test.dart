import 'package:flutter_test/flutter_test.dart';
import 'package:practice_9/main.dart';
import 'package:provider/provider.dart';
import 'package:practice_9/models/cart.dart';

void main() {
  testWidgets('Bookstore displays its books', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(create: (_) => Cart(), child: const Shell()),
    );

    expect(find.text('Books'), findsOneWidget);
    expect(find.text('Widgets All the Way Down'), findsOneWidget);
  });
}
