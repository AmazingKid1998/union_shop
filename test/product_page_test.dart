import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/pages/product_page.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';

void main() {
  
  // 1. SETUP: Create Dummy Products for Testing
  final standardProduct = Product(
    id: 'p1',
    title: 'Basic Tee',
    price: 15.00,
    image: 'assets/tee.jpg',
    description: 'A nice t-shirt',
    collectionId: 'clothing',
  );

  final variantProduct = Product(
    id: 'p2',
    title: 'Hoodie',
    price: 30.00,
    oldPrice: 40.00, // On Sale
    image: 'assets/hoodie_default.jpg',
    description: 'Warm hoodie',
    collectionId: 'clothing',
    variants: {
      'Red': 'assets/hoodie_red.jpg',
      'Blue': 'assets/hoodie_blue.jpg',
    },
  );

  // 2. HELPER: Widget Wrapper
  Widget createTestWidget(Product product, {CartViewModel? cartVM}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => cartVM ?? CartViewModel()),
      ],
      child: MaterialApp(
        home: ProductPage(product: product),
        routes: {
          '/cart': (_) => const Scaffold(body: Text('Cart Screen')), 
        },
      ),
    );
  }

  group('ProductPage UI Tests', () {
    
    testWidgets('Renders standard product details correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(standardProduct));
      expect(find.text('Basic Tee'), findsOneWidget);
      expect(find.text('£15.00'), findsOneWidget);
    });

    testWidgets('Quantity buttons work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(standardProduct));

      // FIX: The buttons are at the bottom, so we MUST scroll to them
      final addBtn = find.byIcon(Icons.add);
      final removeBtn = find.byIcon(Icons.remove);
      
      await tester.ensureVisible(addBtn); // <--- VITAL FIX
      await tester.pumpAndSettle();       // Wait for scroll

      // Initial state
      expect(find.text('1'), findsOneWidget);

      // Tap Plus
      await tester.tap(addBtn);
      await tester.pump();
      expect(find.text('2'), findsOneWidget);

      // Tap Minus
      await tester.tap(removeBtn);
      await tester.pump();
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('Switching Variant updates Image and Text', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(variantProduct));

      // FIX: Scroll to the choice chips
      final blueOption = find.text('Blue');
      await tester.ensureVisible(blueOption); // <--- VITAL FIX
      await tester.pumpAndSettle();

      // Tap 'Blue'
      await tester.tap(blueOption);
      await tester.pump();

      // Verify Text Changed
      expect(find.text('Select Option: Blue'), findsOneWidget);
    });
  });

  group('ProductPage Integration Tests', () {
    testWidgets('Add to Cart adds correct item and quantity', (WidgetTester tester) async {
      // Create a Spy ViewModel
      final cart = CartViewModel();
      await tester.pumpWidget(createTestWidget(variantProduct, cartVM: cart));

      // 1. Scroll to and Select 'Blue' Variant
      final blueOption = find.text('Blue');
      await tester.ensureVisible(blueOption); // <--- FIX
      await tester.pumpAndSettle();
      await tester.tap(blueOption);
      await tester.pump();

      // 2. Scroll to and Increase Quantity
      final addIcon = find.byIcon(Icons.add);
      await tester.ensureVisible(addIcon); // <--- FIX
      await tester.pumpAndSettle();
      await tester.tap(addIcon); // Quantity becomes 2
      await tester.pump();

      // 3. Scroll to and Click Add to Cart
      final addBtn = find.text('ADD TO CART');
      await tester.ensureVisible(addBtn); // <--- FIX
      await tester.pumpAndSettle();
      
      await tester.tap(addBtn);
      await tester.pumpAndSettle(); 

      // 4. VERIFY VIEWMODEL STATE
      expect(cart.rawItems.length, 2); // Should have added 2 items
      expect(cart.rawItems.first.description, 'Variant: Blue'); 
      
      // 5. Verify Navigation
      expect(find.text('Cart Screen'), findsOneWidget);
    });
  });
}