import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/pages/sale_page.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';
import 'package:union_shop/pages/product_page.dart';

// --- MOCK VIEWMODEL ---
// We extend ShopViewModel to override the getSaleItems method.
// This allows us to control exactly what data the page receives during the test.
class MockShopViewModel extends ShopViewModel {
  @override
  List<Product> getSaleItems() {
    return [
      Product(
        id: 's1', 
        title: 'Discount Shirt', 
        price: 15.00, 
        oldPrice: 30.00, // Important: Has oldPrice
        image: 'img.jpg', 
        description: 'Cheap!', 
        collectionId: 'col'
      ),
      Product(
        id: 's2', 
        title: 'Cheap Hat', 
        price: 5.00, 
        oldPrice: 10.00, 
        image: 'img.jpg', 
        description: 'Warm!', 
        collectionId: 'col'
      ),
    ];
  }
}

void main() {
  
  Widget createSaleTest() {
    return MultiProvider(
      providers: [
        // Inject our Mock VM instead of the real one
        ChangeNotifierProvider<ShopViewModel>(create: (_) => MockShopViewModel()),
        // CartVM is needed because SiteHeader/Footer are inside SalePage
        ChangeNotifierProvider(create: (_) => CartViewModel()),
      ],
      child: const MaterialApp(
        home: SalePage(),
      ),
    );
  }

  group('SalePage Visual Tests', () {
    testWidgets('Renders Header and Marketing Text', (WidgetTester tester) async {
      await tester.pumpWidget(createSaleTest());

      // 1. Verify Big Header
      expect(find.text('SALE'), findsOneWidget);
      expect(find.text('Don’t miss out! Get yours before they’re all gone!'), findsOneWidget);

      // 2. Verify Disclaimer
      expect(find.text('All prices shown are inclusive of the discount'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsWidgets);
    });

    testWidgets('Renders Grid with correct Sale Items', (WidgetTester tester) async {
      await tester.pumpWidget(createSaleTest());

      // 1. Verify Items from Mock are displayed
      expect(find.text('Discount Shirt'), findsOneWidget);
      expect(find.text('Cheap Hat'), findsOneWidget);

      // 2. Verify Pricing Logic (Strike-through old price)
      // Note: We use textContaining to avoid strict style matching issues
      expect(find.text('£30.00'), findsOneWidget); // Old Price
      expect(find.text('£15.00'), findsOneWidget); // New Price
    });
  });

  group('SalePage Interaction Tests', () {
    testWidgets('Clicking a sale card navigates to Product Page', (WidgetTester tester) async {
      await tester.pumpWidget(createSaleTest());

      // 1. Find the Card
      final productCard = find.text('Discount Shirt');
      await tester.ensureVisible(productCard);

      // 2. Tap it
      await tester.tap(productCard);
      await tester.pumpAndSettle(); // Wait for navigation

      // 3. Verify we are on Product Page
      // We check for elements unique to ProductPage (e.g., "Add to Cart")
      expect(find.byType(ProductPage), findsOneWidget);
      expect(find.text('ADD TO CART'), findsOneWidget);
    });
  });
}