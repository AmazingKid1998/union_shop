import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/pages/cart_page.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';

void main() {
  
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
      cart.add(productA); 

      await tester.pumpWidget(createCartTest(cartVM: cart));

      // 1. Click EDIT
      final editBtn = find.text('EDIT');
      await tester.tap(editBtn);
      await tester.pump(); 

      // 2. Verify Input Field appears
      // --- THE FIX ---
      // We explicitly look for the TextField inside the Row, ignoring the Footer.
      final qtyInput = find.descendant(
        of: find.byType(CartItemRow), 
        matching: find.byType(TextField)
      );
      
      expect(qtyInput, findsOneWidget);

      // 3. Change Quantity
      await tester.enterText(qtyInput, '5');
      await tester.pump();

      // 4. Click UPDATE
      await tester.tap(find.text('UPDATE'));
      await tester.pump(); 

      // 5. Verify
      expect(cart.totalPrice, 50.00); 
      expect(find.text('Basic Tee (x5)'), findsOneWidget);
    });

    testWidgets('Checkout button clears cart', (WidgetTester tester) async {
      final cart = CartViewModel();
      cart.add(productA);

      await tester.pumpWidget(createCartTest(cartVM: cart));

      final checkoutBtn = find.text('Check out');
      await tester.ensureVisible(checkoutBtn);
      await tester.tap(checkoutBtn);
      await tester.pump(); 

      expect(find.text('Your basket is empty.'), findsOneWidget);
      expect(cart.rawItems.isEmpty, true);
    });
  });
}