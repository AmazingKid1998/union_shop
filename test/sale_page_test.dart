import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/pages/sale_page.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';
import 'package:union_shop/pages/product_page.dart';

// --- MOCK VIEWMODEL: Provides predictable sale data ---
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
        collectionIds: ['c_clothing'],
      ),
    ];
  }
}

// --- HELPER: Test Harness Setup ---
Widget createSaleTest() {
  return MultiProvider(
    providers: [
      // Use the Mock to ensure SalePage always receives items
      ChangeNotifierProvider<ShopViewModel>(create: (_) => MockShopViewModel()), 
      ChangeNotifierProvider(create: (_) => CartViewModel()),
    ],
    child: MaterialApp(
      home: const SalePage(),
      // Mock the navigation target (ProductPage) for the click test
      onGenerateRoute: (settings) {
        if (settings.name?.startsWith('/product/') ?? false) {
          // Simply navigate to a mock screen instead of building the complex ProductPage
          return MaterialPageRoute(
            builder: (_) => const Scaffold(body: Text('Mock Product Screen')),
          );
        }
        return null;
      },
    ),
  );
}

void main() {
  group('SalePage - Core Functionality Tests', () {

    // --- TEST 1: Essential UI & Price Presentation ---
    testWidgets('Renders SALE banner, disclaimer, and product prices correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createSaleTest());
      // Wait for the asynchronous loading (minimal pump should suffice)
      await tester.pumpAndSettle(); 

      // 1. Verify Header/Branding
      expect(find.text('SALE'), findsOneWidget);
      expect(find.text('Don’t miss out! Get yours before they’re all gone!'), findsOneWidget);

      // 2. Verify Product Title
      expect(find.text('Discount Shirt'), findsOneWidget);
      
      // 3. Verify Price Display Logic (The most important part of the sale page)
      expect(find.text('£30.00'), findsOneWidget); // Old Price (should have strikethrough)
      expect(find.text('£15.00'), findsOneWidget); // New Price 
    });

    // --- TEST 2: Navigation Interaction ---
    testWidgets('Clicking a sale card navigates to the mock product page', (WidgetTester tester) async {
      await tester.pumpWidget(createSaleTest());
      await tester.pumpAndSettle();

      final productCard = find.text('Discount Shirt');
      await tester.ensureVisible(productCard);
      await tester.pumpAndSettle();

      // Tap the product card
      await tester.tap(productCard);
      await tester.pumpAndSettle();

      // Verify navigation to the mocked route target
      expect(find.text('Mock Product Screen'), findsOneWidget);
    });
  });
}