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
    // --- Test 1: Basic Rendering ---
    testWidgets('Renders essential UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const PrintShackPage()));
      await tester.pumpAndSettle();

      expect(find.text('Personalisation'), findsOneWidget);
      expect(find.text('£3.00'), findsOneWidget);
      expect(find.text('ADD TO CART'), findsOneWidget);
    });

    // --- Test 2: Error on Empty Text (Tap validation) ---
    testWidgets('Shows error if text is empty', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const PrintShackPage()));
      await tester.pumpAndSettle();

      final addButton = find.text('ADD TO CART');
      
      // FIX: Ensure button is visible before tapping
      await tester.ensureVisible(addButton);
      await tester.pumpAndSettle(); 

      await tester.tap(addButton);
      await tester.pump(); // Trigger frame for SnackBar

      // Verify SnackBar error message
      expect(find.textContaining('Please enter text'), findsOneWidget);
    });

    // --- Test 3: Price and Variant Logic ---
    testWidgets('Can change variant and price updates correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const PrintShackPage()));
      await tester.pumpAndSettle();

      // 1. Verify initial state 
      expect(find.text('£3.00'), findsOneWidget);
      final dropdown = find.byType(DropdownButton<String>);
      
      // FIX: Ensure the dropdown is visible before tapping
      await tester.ensureVisible(dropdown);
      await tester.pumpAndSettle();

      // 2. Tap the dropdown to open the options list
      await tester.tap(dropdown);
      await tester.pumpAndSettle(); 

      // 3. Select 'Three Lines of Text' (Price £7.50)
      final threeLinesOption = find.text('Three Lines of Text');
      await tester.tap(threeLinesOption);
      await tester.pumpAndSettle(); 

      // 4. Verify the price has updated to £7.50
      expect(find.text('£7.50'), findsOneWidget);

      // 5. Verify three input fields are now present (Text after Personalisation Line X:)
      expect(find.textContaining('Personalisation Line 1:'), findsOneWidget);
      expect(find.textContaining('Personalisation Line 2:'), findsOneWidget);
      expect(find.textContaining('Personalisation Line 3:'), findsOneWidget);
      expect(find.textContaining('Personalisation Line 4:'), findsNothing);
    });


    // --- Test 4: Full Flow (Input + Add to Cart + Navigation) ---
    testWidgets('Can enter text and add to cart', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const PrintShackPage()));
      await tester.pumpAndSettle();

      // 1. Enter Text for Line 1 (CORRECTED FINDER SYNTAX)
      final line1Label = find.text('Personalisation Line 1:');
      
      // Find the TextField input that is a sibling of the Line 1 Label (within the same parent column)
      // This is a robust way to find the input box following the label.
      final line1Input = find.descendant(
        of: find.byType(Column).at(1), // Find the Column containing all the form fields
        matching: find.byType(TextField)
      ).first;

      // Ensure the input field is visible if it's off-screen
      await tester.ensureVisible(line1Input);
      await tester.pumpAndSettle();

      await tester.enterText(line1Input, 'My Custom Text');
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

      // 5. Verify Navigation (Check for the destination route's placeholder text)
      expect(find.text('Cart Page'), findsOneWidget);
    });
  });
}