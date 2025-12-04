import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/pages/sale_page.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';
import 'package:union_shop/pages/product_page.dart';

// --- MOCK VIEWMODEL ---
class MockShopViewModel extends ShopViewModel {
  @override
  List<Product> getSaleItems() {
    return [
      Product(
        id: 's1', 
        title: 'Discount Shirt', 
        price: 15.00, 
        oldPrice: 30.00,
        image: 'assets/images/essential_blue.webp', 
        description: 'Cheap!', 
        collectionIds: ['c_clothing'], // Updated to list
      ),
      Product(
        id: 's2', 
        title: 'Cheap Hat', 
        price: 5.00, 
        oldPrice: 10.00, 
        image: 'assets/images/essential_blue.webp', 
        description: 'Warm!', 
        collectionIds: ['c_merch', 'c_clothing'], // Multiple collections
      ),
      Product(
        id: 's3',
        title: 'Sale Hoodie',
        price: 25.00,
        oldPrice: 35.00,
        image: 'assets/images/classichoodie_grey.webp',
        description: 'Cozy!',
        collectionIds: ['c_clothing', 'c_signature'],
      ),
    ];
  }
}

void main() {
  
  Widget createSaleTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ShopViewModel>(create: (_) => MockShopViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
      ],
      child: MaterialApp(
        home: const SalePage(),
        onGenerateRoute: (settings) {
          if (settings.name?.startsWith('/product/') ?? false) {
            final id = settings.name!.split('/').last;
            // Find product from mock
            final mockVM = MockShopViewModel();
            final product = mockVM.getSaleItems().firstWhere(
              (p) => p.id == id,
              orElse: () => mockVM.getSaleItems().first,
            );
            return MaterialPageRoute(
              builder: (_) => ProductPage(product: product),
            );
          }
          return null;
        },
      ),
    );
  }

  group('SalePage Visual Tests', () {
    testWidgets('Renders Header and Marketing Text', (WidgetTester tester) async {
      await tester.pumpWidget(createSaleTest());
      await tester.pumpAndSettle();

      // Verify Big Header
      expect(find.text('SALE'), findsOneWidget);

      // Verify Disclaimer
      expect(find.text('All prices shown are inclusive of the discount'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsWidgets);
    });

    testWidgets('Renders Grid with correct Sale Items', (WidgetTester tester) async {
      await tester.pumpWidget(createSaleTest());
      await tester.pumpAndSettle();

      // Verify Items from Mock are displayed
      expect(find.text('Discount Shirt'), findsOneWidget);
      expect(find.text('Cheap Hat'), findsOneWidget);
      expect(find.text('Sale Hoodie'), findsOneWidget);
    });

    testWidgets('Shows strike-through old price and new price', (WidgetTester tester) async {
      await tester.pumpWidget(createSaleTest());
      await tester.pumpAndSettle();

      // Check prices for Discount Shirt
      expect(find.text('£30.00'), findsOneWidget); // Old Price
      expect(find.text('£15.00'), findsOneWidget); // New Price
    });

    testWidgets('All sale items have oldPrice displayed', (WidgetTester tester) async {
      await tester.pumpWidget(createSaleTest());
      await tester.pumpAndSettle();

      // All three items should show their old prices
      expect(find.text('£30.00'), findsOneWidget); // Shirt old
      expect(find.text('£10.00'), findsOneWidget); // Hat old
      expect(find.text('£35.00'), findsOneWidget); // Hoodie old
    });

    testWidgets('Contains SiteFooter', (WidgetTester tester) async {
      await tester.pumpWidget(createSaleTest());
      await tester.pumpAndSettle();

      // Scroll to footer
      await tester.scrollUntilVisible(
        find.text('Opening Hours'),
        500,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Opening Hours'), findsOneWidget);
    });
  });

  group('SalePage Interaction Tests', () {
    testWidgets('Clicking a sale card navigates to Product Page', (WidgetTester tester) async {
      await tester.pumpWidget(createSaleTest());
      await tester.pumpAndSettle();

      final productCard = find.text('Discount Shirt');
      await tester.ensureVisible(productCard);
      await tester.pumpAndSettle();

      await tester.tap(productCard);
      await tester.pumpAndSettle();

      // Verify navigation to ProductPage
      expect(find.byType(ProductPage), findsOneWidget);
      expect(find.text('ADD TO CART'), findsOneWidget);
    });

    testWidgets('Clicking different sale item works', (WidgetTester tester) async {
      await tester.pumpWidget(createSaleTest());
      await tester.pumpAndSettle();

      final hatCard = find.text('Cheap Hat');
      await tester.ensureVisible(hatCard);
      await tester.pumpAndSettle();

      await tester.tap(hatCard);
      await tester.pumpAndSettle();

      expect(find.byType(ProductPage), findsOneWidget);
    });
  });

  group('SalePage Grid Layout Tests', () {
    testWidgets('Uses GridView for items', (WidgetTester tester) async {
      await tester.pumpWidget(createSaleTest());
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('Grid has correct number of items', (WidgetTester tester) async {
      await tester.pumpWidget(createSaleTest());
      await tester.pumpAndSettle();

      // Find GestureDetectors within the grid (each sale card)
      final cards = find.descendant(
        of: find.byType(GridView),
        matching: find.byType(GestureDetector),
      );

      expect(cards, findsNWidgets(3));
    });
  });
}