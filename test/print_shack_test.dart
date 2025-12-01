import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/main.dart';
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
      
      // Check Default Price
      expect(find.text('£3.00'), findsOneWidget);

      // Check "ADD TO CART" button
      expect(find.text('ADD TO CART'), findsOneWidget);
    });

    testWidgets('Shows error if text is empty', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const PrintShackPage()));
      await tester.pumpAndSettle();

      final addButton = find.text('ADD TO CART');
      await tester.ensureVisible(addButton);
      await tester.pumpAndSettle();

      await tester.tap(addButton);
      await tester.pump(); 

      // Verify SnackBar error message
      expect(find.textContaining('Please enter text'), findsOneWidget);
    });

    testWidgets('Can change variant and price updates correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const PrintShackPage()));
      await tester.pumpAndSettle();

      // 1. Verify initial state (One Line of Text, Price £3.00)
      expect(find.text('£3.00'), findsOneWidget);
      expect(find.textContaining('Personalisation Line 1:'), findsOneWidget);
      expect(find.textContaining('Personalisation Line 2:'), findsNothing); // Should only have 1 line initially

      // 2. Tap the dropdown to open the options list
      final dropdown = find.byType(DropdownButton<String>);
      await tester.tap(dropdown);
      await tester.pumpAndSettle(); // Wait for the options overlay to appear

      // 3. Select 'Three Lines of Text' (Price £7.50)
      final threeLinesOption = find.text('Three Lines of Text');
      await tester.tap(threeLinesOption);
      await tester.pumpAndSettle(); // Wait for the UI to update

      // 4. Verify the price has updated to £7.50
      expect(find.text('£7.50'), findsOneWidget);

      // 5. Verify three input fields are now present
      expect(find.textContaining('Personalisation Line 1:'), findsOneWidget);
      expect(find.textContaining('Personalisation Line 2:'), findsOneWidget);
      expect(find.textContaining('Personalisation Line 3:'), findsOneWidget);
      expect(find.textContaining('Personalisation Line 4:'), findsNothing);
    });


    testWidgets('Can enter text and add to cart', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const PrintShackPage()));
      await tester.pumpAndSettle();

      // 1. Enter Text for Line 1
      final textField = find.byType(TextField).first; 
      await tester.enterText(textField, 'My Custom Text');
      await tester.pump();

      // 2. Change Quantity 
      final qtyField = find.widgetWithText(TextField, '1');
      await tester.enterText(qtyField, '2');
      await tester.pump();

      // 3. Find and ensure visibility of the Add to Cart button
      final addToCartButton = find.text('ADD TO CART');
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle(); 

      // 4. Tap Add to Cart
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle(); 

      // 5. Verify Navigation
      expect(find.text('Cart Page'), findsOneWidget);
    });
  });
}