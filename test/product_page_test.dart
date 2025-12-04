import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/pages/product_page.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';

void main() {
  
  // SETUP: Create Dummy Products for Testing
  final standardProduct = Product(
    id: 'p1',
    title: 'Basic Tee',
    price: 15.00,
    image: 'assets/images/essential_blue.webp',
    description: 'A nice t-shirt',
    collectionIds: ['c_clothing'],
  );

  final variantProduct = Product(
    id: 'p2',
    title: 'Hoodie',
    price: 30.00,
    oldPrice: 40.00, // On Sale
    image: 'assets/images/classichoodie_grey.webp',
    description: 'Warm hoodie',
    collectionIds: ['c_clothing', 'c_signature'], // Multiple collections
    variants: {
      'Red': 'assets/images/classichoodie_grey.webp',
      'Blue': 'assets/images/classichoodie_navy.webp',
    },
  );

  final multiCollectionProduct = Product(
    id: 'p3',
    title: 'Multi Collection Item',
    price: 25.00,
    image: 'assets/images/graduation_p2.webp',
    description: 'In multiple collections',
    collectionIds: ['c_clothing', 'c_grad', 'c_signature'],
  );

  // HELPER: Widget Wrapper
  Widget createTestWidget(Product product, {CartViewModel? cartVM}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => cartVM ?? CartViewModel()),
        ChangeNotifierProvider(create: (_) => ShopViewModel()),
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
      await tester.pumpAndSettle();
      
      expect(find.text('Basic Tee'), findsOneWidget);
      expect(find.text('£15.00'), findsOneWidget);
      expect(find.text('A nice t-shirt'), findsOneWidget);
    });

    testWidgets('Renders sale product with both prices', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(variantProduct));
      await tester.pumpAndSettle();
      
      expect(find.text('£40.00'), findsOneWidget); // Old price
      expect(find.text('£30.00'), findsOneWidget); // Current price
    });

    testWidgets('Quantity buttons work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(standardProduct));
      await tester.pumpAndSettle();

      final addBtn = find.byIcon(Icons.add);
      final removeBtn = find.byIcon(Icons.remove);
      
      await tester.ensureVisible(addBtn);
      await tester.pumpAndSettle();

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

    testWidgets('Quantity cannot go below 1', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(standardProduct));
      await tester.pumpAndSettle();

      final removeBtn = find.byIcon(Icons.remove);
      await tester.ensureVisible(removeBtn);
      await tester.pumpAndSettle();

      // Try to decrease below 1
      await tester.tap(removeBtn);
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('0'), findsNothing);
    });

    testWidgets('Variant selector appears for products with variants', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(variantProduct));
      await tester.pumpAndSettle();

      expect(find.text('Red'), findsOneWidget);
      expect(find.text('Blue'), findsOneWidget);
    });

    testWidgets('No variant selector for products without variants', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(standardProduct));
      await tester.pumpAndSettle();

      expect(find.textContaining('Select Option'), findsNothing);
    });

    testWidgets('Switching Variant updates display', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(variantProduct));
      await tester.pumpAndSettle();

      final blueOption = find.text('Blue');
      await tester.ensureVisible(blueOption);
      await tester.pumpAndSettle();

      // Tap 'Blue'
      await tester.tap(blueOption);
      await tester.pump();

      // Verify Text Changed
      expect(find.text('Select Option: Blue'), findsOneWidget);
    });

    testWidgets('Add to Cart button exists', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(standardProduct));
      await tester.pumpAndSettle();

      final addBtn = find.text('ADD TO CART');
      await tester.ensureVisible(addBtn);
      
      expect(addBtn, findsOneWidget);
    });
  });

  group('ProductPage Integration Tests', () {
    testWidgets('Add to Cart adds correct item and quantity', (WidgetTester tester) async {
      final cart = CartViewModel();
      await tester.pumpWidget(createTestWidget(variantProduct, cartVM: cart));
      await tester.pumpAndSettle();

      // Select 'Blue' Variant
      final blueOption = find.text('Blue');
      await tester.ensureVisible(blueOption);
      await tester.pumpAndSettle();
      await tester.tap(blueOption);
      await tester.pump();

      // Increase Quantity
      final addIcon = find.byIcon(Icons.add);
      await tester.ensureVisible(addIcon);
      await tester.pumpAndSettle();
      await tester.tap(addIcon); // Quantity becomes 2
      await tester.pump();

      // Click Add to Cart
      final addBtn = find.text('ADD TO CART');
      await tester.ensureVisible(addBtn);
      await tester.pumpAndSettle();
      
      await tester.tap(addBtn);
      await tester.pumpAndSettle(); 

      // VERIFY VIEWMODEL STATE
      expect(cart.rawItems.length, 2);
      expect(cart.rawItems.first.description, 'Variant: Blue'); 
      
      // Verify Navigation
      expect(find.text('Cart Screen'), findsOneWidget);
    });

    testWidgets('Add to Cart with default variant', (WidgetTester tester) async {
      final cart = CartViewModel();
      await tester.pumpWidget(createTestWidget(variantProduct, cartVM: cart));
      await tester.pumpAndSettle();

      // Don't select variant, use default (Red)
      final addBtn = find.text('ADD TO CART');
      await tester.ensureVisible(addBtn);
      await tester.pumpAndSettle();
      
      await tester.tap(addBtn);
      await tester.pumpAndSettle();

      expect(cart.rawItems.length, 1);
      expect(cart.rawItems.first.description, 'Variant: Red');
    });

    testWidgets('Standard product adds to cart correctly', (WidgetTester tester) async {
      final cart = CartViewModel();
      await tester.pumpWidget(createTestWidget(standardProduct, cartVM: cart));
      await tester.pumpAndSettle();

      final addBtn = find.text('ADD TO CART');
      await tester.ensureVisible(addBtn);
      await tester.pumpAndSettle();
      
      await tester.tap(addBtn);
      await tester.pumpAndSettle();

      expect(cart.rawItems.length, 1);
      expect(cart.totalPrice, 15.00);
    });

    testWidgets('Shows snackbar on add to cart', (WidgetTester tester) async {
      final cart = CartViewModel();
      await tester.pumpWidget(createTestWidget(standardProduct, cartVM: cart));
      await tester.pumpAndSettle();

      final addBtn = find.text('ADD TO CART');
      await tester.ensureVisible(addBtn);
      await tester.pumpAndSettle();
      
      await tester.tap(addBtn);
      await tester.pump(); // Just pump once to see snackbar

      expect(find.textContaining('added'), findsOneWidget);
    });
  });

  group('ProductPage with Multiple Collection Products', () {
    testWidgets('Product with multiple collections adds to cart correctly', (WidgetTester tester) async {
      final cart = CartViewModel();
      await tester.pumpWidget(createTestWidget(multiCollectionProduct, cartVM: cart));
      await tester.pumpAndSettle();

      final addBtn = find.text('ADD TO CART');
      await tester.ensureVisible(addBtn);
      await tester.pumpAndSettle();
      
      await tester.tap(addBtn);
      await tester.pumpAndSettle();

      expect(cart.rawItems.length, 1);
      expect(cart.rawItems.first.collectionIds.length, 3);
    });
  });

  group('ProductPage Footer and Header', () {
    testWidgets('Contains SiteHeader and SiteFooter', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(standardProduct));
      await tester.pumpAndSettle();

      // Header icons
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsWidgets);
    });
  });
}