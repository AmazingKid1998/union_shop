import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';
import 'package:union_shop/pages/print_shack_page.dart';

// Helper to wrap widget with providers
Widget createTestWidget(Widget child, {CartViewModel? cartVM}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => cartVM ?? CartViewModel()),
      ChangeNotifierProvider(create: (_) => ShopViewModel()),
    ],
    child: MaterialApp(
      home: child,
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
      expect(find.text('Tax included.'), findsOneWidget);
    });

    // --- Test 2: Breadcrumb ---
    testWidgets('Shows breadcrumb navigation', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const PrintShackPage()));
      await tester.pumpAndSettle();

      expect(find.text('Home / Personalise Text'), findsOneWidget);
    });

    // --- Test 3: Error on Empty Text ---
    testWidgets('Shows error if text is empty', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const PrintShackPage()));
      await tester.pumpAndSettle();

      final addButton = find.text('ADD TO CART');
      await tester.ensureVisible(addButton);
      await tester.pumpAndSettle(); 

      await tester.tap(addButton);
      await tester.pump();

      expect(find.textContaining('Please enter text'), findsOneWidget);
    });

    // --- Test 4: Dropdown Options ---
    testWidgets('Dropdown contains all pricing options', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const PrintShackPage()));
      await tester.pumpAndSettle();

      final dropdown = find.byType(DropdownButton<String>);
      await tester.ensureVisible(dropdown);
      await tester.pumpAndSettle();

      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      expect(find.text('One Line of Text'), findsWidgets);
      expect(find.text('Two Lines of Text'), findsOneWidget);
      expect(find.text('Three Lines of Text'), findsOneWidget);
      expect(find.text('Four Lines of Text'), findsOneWidget);
      expect(find.text('Small Logo (Chest)'), findsOneWidget);
      expect(find.text('Large Logo (Back)'), findsOneWidget);
    });

    // --- Test 5: Price Updates on Selection ---
    testWidgets('Can change variant and price updates correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const PrintShackPage()));
      await tester.pumpAndSettle();

      // Verify initial state 
      expect(find.text('£3.00'), findsOneWidget);
      
      final dropdown = find.byType(DropdownButton<String>);
      await tester.ensureVisible(dropdown);
      await tester.pumpAndSettle();

      // Tap dropdown
      await tester.tap(dropdown);
      await tester.pumpAndSettle(); 

      // Select 'Three Lines of Text' (Price £7.50)
      final threeLinesOption = find.text('Three Lines of Text').last;
      await tester.tap(threeLinesOption);
      await tester.pumpAndSettle(); 

      // Verify the price has updated
      expect(find.text('£7.50'), findsOneWidget);
    });

    // --- Test 6: Dynamic Text Fields ---
    testWidgets('Correct number of text fields appear for selection', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const PrintShackPage()));
      await tester.pumpAndSettle();

      final dropdown = find.byType(DropdownButton<String>);
      await tester.ensureVisible(dropdown);
      await tester.pumpAndSettle();

      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Three Lines of Text').last);
      await tester.pumpAndSettle();

      // Verify three input field labels
      expect(find.textContaining('Personalisation Line 1:'), findsOneWidget);
      expect(find.textContaining('Personalisation Line 2:'), findsOneWidget);
      expect(find.textContaining('Personalisation Line 3:'), findsOneWidget);
      expect(find.textContaining('Personalisation Line 4:'), findsNothing);
    });

    // --- Test 7: Full Flow ---
    testWidgets('Can enter text and add to cart', (WidgetTester tester) async {
      final cart = CartViewModel();
      await tester.pumpWidget(createTestWidget(const PrintShackPage(), cartVM: cart));
      await tester.pumpAndSettle();

      // Find first text input field
      final textFields = find.byType(TextField);
      final line1Input = textFields.first;
      
      await tester.ensureVisible(line1Input);
      await tester.pumpAndSettle();

      await tester.enterText(line1Input, 'My Custom Text');
      await tester.pump();

      // Find and tap Add to Cart
      final addToCartButton = find.text('ADD TO CART');
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle(); 

      await tester.tap(addToCartButton);
      await tester.pumpAndSettle(); 

      // Verify Navigation
      expect(find.text('Cart Page'), findsOneWidget);
      
      // Verify cart has item with correct collectionIds (custom)
      expect(cart.rawItems.length, 1);
      expect(cart.rawItems.first.collectionIds, contains('custom'));
    });

    // --- Test 8: Multiple Quantities ---
    testWidgets('Adding multiple quantities creates multiple items', (WidgetTester tester) async {
      final cart = CartViewModel();
      await tester.pumpWidget(createTestWidget(const PrintShackPage(), cartVM: cart));
      await tester.pumpAndSettle();

      // Enter text
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'Test Line');
      await tester.pump();

      // Change quantity to 3
      final qtyField = find.widgetWithText(TextField, '1');
      await tester.ensureVisible(qtyField);
      await tester.enterText(qtyField, '3');
      await tester.pump();

      // Add to cart
      final addToCartButton = find.text('ADD TO CART');
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle();

      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Should have 3 items (each with unique ID)
      expect(cart.rawItems.length, 3);
    });

    // --- Test 9: Two Lines Selection ---
    testWidgets('Two lines option shows two input fields', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const PrintShackPage()));
      await tester.pumpAndSettle();

      final dropdown = find.byType(DropdownButton<String>);
      await tester.ensureVisible(dropdown);
      await tester.pumpAndSettle();

      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Two Lines of Text').last);
      await tester.pumpAndSettle();

      expect(find.textContaining('Personalisation Line 1:'), findsOneWidget);
      expect(find.textContaining('Personalisation Line 2:'), findsOneWidget);
      expect(find.textContaining('Personalisation Line 3:'), findsNothing);
    });

    // --- Test 10: Four Lines Selection ---
    testWidgets('Four lines option shows four input fields', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const PrintShackPage()));
      await tester.pumpAndSettle();

      final dropdown = find.byType(DropdownButton<String>);
      await tester.ensureVisible(dropdown);
      await tester.pumpAndSettle();

      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Four Lines of Text').last);
      await tester.pumpAndSettle();

      expect(find.textContaining('Personalisation Line 1:'), findsOneWidget);
      expect(find.textContaining('Personalisation Line 2:'), findsOneWidget);
      expect(find.textContaining('Personalisation Line 3:'), findsOneWidget);
      expect(find.textContaining('Personalisation Line 4:'), findsOneWidget);
      expect(find.text('£10.00'), findsOneWidget);
    });

    // --- Test 11: Logo Options ---
    testWidgets('Logo options show correct prices', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const PrintShackPage()));
      await tester.pumpAndSettle();

      final dropdown = find.byType(DropdownButton<String>);
      await tester.ensureVisible(dropdown);
      await tester.pumpAndSettle();

      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      // Select Small Logo
      await tester.tap(find.text('Small Logo (Chest)').last);
      await tester.pumpAndSettle();

      expect(find.text('£3.00'), findsOneWidget);

      // Change to Large Logo
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Large Logo (Back)').last);
      await tester.pumpAndSettle();

      expect(find.text('£6.00'), findsOneWidget);
    });

    // --- Test 12: Validation for Multiple Lines ---
    testWidgets('Validation works for multiple line options', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const PrintShackPage()));
      await tester.pumpAndSettle();

      // Select Two Lines option
      final dropdown = find.byType(DropdownButton<String>);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Two Lines of Text').last);
      await tester.pumpAndSettle();

      // Only fill first line
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'Line One');
      await tester.pump();

      // Try to add to cart
      final addToCartButton = find.text('ADD TO CART');
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle();
      await tester.tap(addToCartButton);
      await tester.pump();

      // Should show error for Line 2
      expect(find.textContaining('Please enter text for Line 2'), findsOneWidget);
    });
  });
}