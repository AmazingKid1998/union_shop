import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/main.dart'; // Adjust path if needed
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';
import 'package:union_shop/pages/print_shack_page.dart';

// Helper to wrap widget with providers
Widget createTestWidget(Widget child) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ShopViewModel()),
      ChangeNotifierProvider(create: (_) => CartViewModel()),
    ],
    child: MaterialApp(
      home: child,
      // Define routes needed for navigation
      routes: {
        '/cart': (context) => const Scaffold(body: Text('Cart Page')),
      },
    ),
  );
}

void main() {
  group('PrintShackPage Tests', () {
    testWidgets('Renders essential UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const PrintShackPage()));
      await tester.pumpAndSettle();

      // Check Title
      expect(find.text('Personalisation'), findsOneWidget);
      
      // Check Price (Default £3.00)
      expect(find.text('£3.00'), findsOneWidget);

      // Check Dropdown Label
      expect(find.textContaining('Per Line:'), findsOneWidget);

      // Check "ADD TO CART" button
      expect(find.text('ADD TO CART'), findsOneWidget);
    });

    testWidgets('Shows error if text is empty', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const PrintShackPage()));
      await tester.pumpAndSettle();

      // Find the Add button
      final addButton = find.text('ADD TO CART');
      
      // Tap it without entering text
      await tester.tap(addButton);
      await tester.pump(); // Trigger frame

      // Expect a SnackBar with error message
      expect(find.textContaining('Please enter text'), findsOneWidget);
    });

    testWidgets('Can enter text and add to cart', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const PrintShackPage()));
      await tester.pumpAndSettle();

      // 1. Enter Text
      // Find the text field (it's the one under "Personalisation Line 1")
      final textField = find.byType(TextField).first; 
      await tester.enterText(textField, 'My Custom Text');
      await tester.pump();

      // 2. Change Quantity (Optional, but good to test)
      // Find the quantity field (it has '1' initially)
      final qtyField = find.widgetWithText(TextField, '1');
      await tester.enterText(qtyField, '2');
      await tester.pump();

      // 3. Tap Add to Cart
      await tester.tap(find.text('ADD TO CART'));
      await tester.pumpAndSettle(); // Wait for navigation

      // 4. Verify Navigation
      // Should satisfy the expectation that we moved to the '/cart' route (which renders "Cart Page" text in our test harness)
      expect(find.text('Cart Page'), findsOneWidget);
    });
  });
}