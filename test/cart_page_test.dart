import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/pages/cart_page.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';

void main() {
  
  final productA = Product(
    id: 'p1', 
    title: 'Basic Tee', 
    price: 10.00, 
    image: 'assets/images/test.webp', 
    description: 'Variant: Red', 
    collectionIds: ['c_clothing'], // Updated to list
  );

  final productB = Product(
    id: 'p2', 
    title: 'Custom Hoodie', 
    price: 20.00, 
    image: 'assets/images/test.webp', 
    description: 'Three Lines: A / B / C', 
    collectionIds: ['c_clothing', 'c_signature'], // Multiple collections
  );

  final saleProduct = Product(
    id: 'p3',
    title: 'Sale Item',
    price: 15.00,
    oldPrice: 25.00,
    image: 'assets/images/sale.webp',
    description: 'Variant: Blue',
    collectionIds: ['c_clothing'],
  );

  Widget createCartTest({CartViewModel? cartVM}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => cartVM ?? CartViewModel()),
        ChangeNotifierProvider(create: (_) => ShopViewModel()),
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
      await tester.pumpAndSettle();
      
      expect(find.text('Your basket is empty.'), findsOneWidget);
    });

    testWidgets('Shows page title', (WidgetTester tester) async {
      await tester.pumpWidget(createCartTest());
      await tester.pumpAndSettle();
      
      expect(find.text('Your cart'), findsOneWidget);
    });

    testWidgets('Shows continue shopping link', (WidgetTester tester) async {
      await tester.pumpWidget(createCartTest());
      await tester.pumpAndSettle();
      
      expect(find.text('Continue shopping'), findsOneWidget);
    });

    testWidgets('Renders items and calculates subtotal correctly', (WidgetTester tester) async {
      final cart = CartViewModel();
      cart.add(productA); 
      cart.add(productB); 
      cart.add(productB); 

      await tester.pumpWidget(createCartTest(cartVM: cart));
      await tester.pumpAndSettle();

      expect(find.text('Basic Tee'), findsOneWidget);
      expect(find.text('Custom Hoodie (x2)'), findsOneWidget);
      expect(find.text('£50.00'), findsOneWidget); // 10 + 20 + 20
    });

    testWidgets('Shows table headers when items present', (WidgetTester tester) async {
      final cart = CartViewModel();
      cart.add(productA);

      await tester.pumpWidget(createCartTest(cartVM: cart));
      await tester.pumpAndSettle();

      expect(find.text('Product'), findsOneWidget);
      expect(find.text('Price'), findsOneWidget);
    });

    testWidgets('Shows checkout section when items present', (WidgetTester tester) async {
      final cart = CartViewModel();
      cart.add(productA);

      await tester.pumpWidget(createCartTest(cartVM: cart));
      await tester.pumpAndSettle();

      final checkoutBtn = find.text('Check out');
      await tester.ensureVisible(checkoutBtn);
      
      expect(find.text('Subtotal'), findsOneWidget);
      expect(find.text('Check out'), findsOneWidget);
    });
  });

  group('CartPage Interaction Tests', () {
    testWidgets('Edit mode allows updating quantity', (WidgetTester tester) async {
      final cart = CartViewModel();
      cart.add(productA); 

      await tester.pumpWidget(createCartTest(cartVM: cart));
      await tester.pumpAndSettle();

      // 1. Click EDIT
      final editBtn = find.text('EDIT');
      await tester.tap(editBtn);
      await tester.pump(); 

      // 2. Verify Input Field appears
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

    testWidgets('Cancel edit reverts changes', (WidgetTester tester) async {
      final cart = CartViewModel();
      cart.add(productA);

      await tester.pumpWidget(createCartTest(cartVM: cart));
      await tester.pumpAndSettle();

      // Enter edit mode
      await tester.tap(find.text('EDIT'));
      await tester.pump();

      // Click CANCEL
      await tester.tap(find.text('CANCEL'));
      await tester.pump();

      // Should be back to normal view
      expect(find.text('EDIT'), findsOneWidget);
      expect(find.text('CANCEL'), findsNothing);
    });

    testWidgets('Remove link removes item from cart', (WidgetTester tester) async {
      final cart = CartViewModel();
      cart.add(productA);
      cart.add(productB);

      await tester.pumpWidget(createCartTest(cartVM: cart));
      await tester.pumpAndSettle();

      // Enter edit mode for first item
      final editButtons = find.text('EDIT');
      await tester.tap(editButtons.first);
      await tester.pump();

      // Click Remove
      await tester.tap(find.text('Remove'));
      await tester.pump();

      // Verify item removed
      expect(cart.rawItems.length, 1);
      expect(cart.rawItems.first.id, 'p2');
    });

    testWidgets('Checkout button clears cart', (WidgetTester tester) async {
      final cart = CartViewModel();
      cart.add(productA);

      await tester.pumpWidget(createCartTest(cartVM: cart));
      await tester.pumpAndSettle();

      final checkoutBtn = find.text('Check out');
      await tester.ensureVisible(checkoutBtn);
      await tester.pumpAndSettle();
      
      await tester.tap(checkoutBtn);
      await tester.pump(); 

      expect(find.text('Your basket is empty.'), findsOneWidget);
      expect(cart.rawItems.isEmpty, true);
    });

    testWidgets('Continue shopping navigates to shop', (WidgetTester tester) async {
      await tester.pumpWidget(createCartTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Continue shopping'));
      await tester.pumpAndSettle();

      expect(find.text('Shop Screen'), findsOneWidget);
    });
  });

  group('CartPage Product Display Tests', () {
    testWidgets('Displays variant information correctly', (WidgetTester tester) async {
      final cart = CartViewModel();
      cart.add(productA);

      await tester.pumpWidget(createCartTest(cartVM: cart));
      await tester.pumpAndSettle();

      expect(find.textContaining('Color: Red'), findsOneWidget);
    });

    testWidgets('Displays custom personalisation details', (WidgetTester tester) async {
      final customProduct = Product(
        id: 'custom_123',
        title: 'Personalisation',
        price: 5.00,
        image: 'assets/images/print_preview.jpg',
        description: 'Two Lines of Text: Hello / World',
        collectionIds: ['custom'],
      );

      final cart = CartViewModel();
      cart.add(customProduct);

      await tester.pumpWidget(createCartTest(cartVM: cart));
      await tester.pumpAndSettle();

      expect(find.text('Personalisation'), findsOneWidget);
    });

    testWidgets('Shows correct price for multiple items', (WidgetTester tester) async {
      final cart = CartViewModel();
      cart.add(productA);
      cart.add(productA);
      cart.add(productA);

      await tester.pumpWidget(createCartTest(cartVM: cart));
      await tester.pumpAndSettle();

      expect(find.text('£30.00'), findsOneWidget); // 10 * 3
      expect(find.text('Basic Tee (x3)'), findsOneWidget);
    });
  });

  group('CartPage with Sale Items', () {
    testWidgets('Sale items show current price in cart', (WidgetTester tester) async {
      final cart = CartViewModel();
      cart.add(saleProduct);

      await tester.pumpWidget(createCartTest(cartVM: cart));
      await tester.pumpAndSettle();

      expect(find.text('£15.00'), findsOneWidget);
      // Cart should use current price, not old price
      expect(cart.totalPrice, 15.00);
    });
  });
}