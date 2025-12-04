import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/models/product.dart';

// Import our modified pages
import 'package:union_shop/pages/collections_page.dart';
import 'package:union_shop/pages/collection_detail_page.dart';
import 'package:union_shop/pages/sale_page.dart';
import 'package:union_shop/pages/product_page.dart';

// Import our Mock
import '../mocks/mock_cart_viewmodel.dart';

// A simple Empty Header to use in tests (Replaces SiteHeader)
final testHeader = AppBar(title: const Text("TEST HEADER"));

// Helper to wrap pages with the required data (ShopVM and MockCartVM)
Widget createPageForTesting(Widget child) {
  return MultiProvider(
    providers: [
      // Real ShopViewModel (Safe because it uses local data)
      ChangeNotifierProvider(create: (_) => ShopViewModel()),
      // Mock CartViewModel (Safe because it doesn't use Firebase)
      ChangeNotifierProvider<CartViewModel>(create: (_) => MockCartViewModel()),
    ],
    child: MaterialApp(
      home: child,
      // Dummy route to catch navigation
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (_) => const Scaffold(body: Text('Navigated')),
      ),
    ),
  );
}

void main() {
  group('Safe Page Tests (No Firebase)', () {
    
    // --- 1. COLLECTIONS PAGE ---
    testWidgets('CollectionsPage renders categories', (WidgetTester tester) async {
      // Use a big screen to avoid overflow
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createPageForTesting(
        CollectionsPage(testHeader: testHeader)
      ));

      // Check for categories
      expect(find.text('Shop by Category'), findsOneWidget);
      expect(find.text('Clothing'), findsOneWidget);
      expect(find.text('Merchandise'), findsOneWidget);
      
      addTearDown(tester.view.resetPhysicalSize);
    });

    // --- 2. SALE PAGE ---
    testWidgets('SalePage renders sale items', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createPageForTesting(
        SalePage(testHeader: testHeader)
      ));

      expect(find.text('SALE'), findsOneWidget);
      // We expect to find prices crossed out (the sale logic)
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);

      addTearDown(tester.view.resetPhysicalSize);
    });

    // --- 3. COLLECTION DETAIL PAGE ---
    testWidgets('CollectionDetailPage filters products', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createPageForTesting(
        CollectionDetailPage(
          collectionId: 'c_clothing',
          title: 'Clothing',
          testHeader: testHeader,
        )
      ));

      expect(find.text('Clothing'), findsOneWidget);
      expect(find.text('Sort By'), findsOneWidget);
      // Should find at least one product image
      expect(find.byType(Image), findsWidgets);

      addTearDown(tester.view.resetPhysicalSize);
    });

    // --- 4. PRODUCT PAGE ---
    testWidgets('ProductPage renders and adds to cart', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;

      final testProduct = Product(
        id: 'p_test',
        title: 'Test Hoodie',
        price: 20.00,
        image: 'assets/images/classichoodie_grey.webp',
        description: 'A test hoodie.',
        collectionIds: ['c_test'],
      );

      await tester.pumpWidget(createPageForTesting(
        ProductPage(product: testProduct, testHeader: testHeader)
      ));

      // Verify product details shown
      expect(find.text('Test Hoodie'), findsOneWidget);
      expect(find.text('£20.00'), findsOneWidget);

      // Verify Add to Cart button exists
      expect(find.text('ADD TO CART'), findsOneWidget);

      // Tap Add to Cart
      await tester.tap(find.text('ADD TO CART'));
      await tester.pump(); // Start animation
      await tester.pump(const Duration(seconds: 3)); // Finish snackbar animation

      // Verify Snackbar appeared
      expect(find.text('Test Hoodie added (x1)!'), findsOneWidget);

      addTearDown(tester.view.resetPhysicalSize);
    });

  });
}