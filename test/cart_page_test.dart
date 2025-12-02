import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/pages/cart_page.dart'; // Ensure CartItemRow is accessible
import 'package:union_shop/viewmodels/cart_viewmodel.dart';

void main() {
  
  // 1. SETUP DUMMY DATA
  final productA = Product(
    id: 'p1', title: 'Basic Tee', price: 10.00, 
    image: 'img.jpg', description: 'Variant: Red', collectionId: 'col'
  );

  final productB = Product(
    id: 'p2', title: 'Custom Hoodie', price: 20.00, 
    image: 'img.jpg', description: 'Three Lines: A / B / C', collectionId: 'col'
  );

  Widget createCartTest({CartViewModel? cartVM}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => cartVM ?? CartViewModel()),
      ],
      child: MaterialApp(
        home: const CartPage(),
        routes: {
          '/shop': (_) => const Scaffold(body: Text('Shop Screen')),
        },
      ),
    );
  }

  group('CartPage Visual Tests', () {
    testWidgets('Shows empty message when cart is empty', (WidgetTester tester) async {
      await tester.pumpWidget(createCartTest());
      expect(find.text('Your basket is empty.'), findsOneWidget);
    });

    testWidgets('Renders items and calculates subtotal correctly', (WidgetTester tester) async {
      final cart = CartViewModel();
      cart.add(productA); 
      cart.add(productB); 
      cart.add(productB); 

      await tester.pumpWidget(createCartTest(cartVM: cart));

      expect(find.text('Basic Tee'), findsOneWidget);
      expect(find.text('Custom Hoodie (x2)'), findsOneWidget);
      expect(find.text('£50.00'), findsOneWidget);
    });
  });

  group('CartPage Interaction Tests', () {
    testWidgets('Edit mode allows updating quantity', (WidgetTester tester) async {
      final cart = CartViewModel();
      cart.add(productA); // Start with 1

      await tester.pumpWidget(createCartTest(cartVM: cart));

      // 1. Click EDIT
      final editBtn = find.text('EDIT');
      await tester.tap(editBtn);
      await tester.pump(); // Rebuild for Edit Mode

      // 2. Verify Input Field appears
      // FIX: Be specific! Find the TextField inside the CartItemRow only.
      // This ignores the Email TextField in the footer.
      final qtyInput = find.descendant(
        of: find.byType(CartItemRow), 
        matching: find.byType(TextField)
      );
      
      expect(qtyInput, findsOneWidget);

      // 3. Change Quantity to 5
      await tester.enterText(qtyInput, '5');
      await tester.pump();

      // 4. Click UPDATE
      await tester.tap(find.text('UPDATE'));
      await tester.pump(); 

      // 5. Verify ViewModel updated
      expect(cart.totalPrice, 50.00); // 5 * 10
      expect(find.text('Basic Tee (x5)'), findsOneWidget);
    });

    testWidgets('Checkout button clears cart', (WidgetTester tester) async {
      final cart = CartViewModel();
      cart.add(productA);

      await tester.pumpWidget(createCartTest(cartVM: cart));

      // 1. Scroll to Checkout
      final checkoutBtn = find.text('Check out');
      await tester.ensureVisible(checkoutBtn);
      
      // 2. Click it
      await tester.tap(checkoutBtn);
      await tester.pump(); 

      // 3. Verify Cart Cleared
      expect(find.text('Your basket is empty.'), findsOneWidget);
      expect(cart.rawItems.isEmpty, true);
    });
  });
}