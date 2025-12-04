import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/widgets/product_search_delegate.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart'; 

// NOTE: Since ProductSearchDelegate relies on ShopViewModel/CartViewModel
// for context/dependencies, we must include them in the MultiProvider setup.

// --- HELPER: Minimal Test Harness to open the search bar ---
Widget createSearchTest() {
  return MultiProvider(
    providers: [
      // ShopViewModel is needed for the ProductRepository call inside the delegate.
      ChangeNotifierProvider(create: (_) => ShopViewModel()),
      // CartViewModel is often required by the SiteHeader, even if unused directly by the delegate.
      // This is a common point of failure if Firebase isn't initialized.
      ChangeNotifierProvider(create: (_) => CartViewModel()), 
    ],
    child: MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            // Button to trigger the search view
            return ElevatedButton(
              onPressed: () async {
                await showSearch(
                  context: context, 
                  delegate: ProductSearchDelegate()
                );
              }, 
              child: const Text('OPEN SEARCH')
            );
          }
        ),
      ),
      onGenerateRoute: (settings) {
        // Mock the navigation target when a search result is clicked
        if (settings.name?.startsWith('/product/') ?? false) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(body: Text('Product Detail Page')),
          );
        }
        return null;
      },
    ),
  );
}

void main() {
  group('ProductSearchDelegate - Basic Flow Tests', () {

    testWidgets('Opens, searches for "Hoodie", and displays a result', (WidgetTester tester) async {
      await tester.pumpWidget(createSearchTest());
      await tester.pumpAndSettle();

      // 1. Open search
      await tester.tap(find.text('OPEN SEARCH'));
      await tester.pumpAndSettle();

      // 2. Type a generic query expected to return results
      await tester.enterText(find.byType(TextField), 'hoodie');
      
      // Give time for the asynchronous repository call to complete and the results to build
      await tester.pumpAndSettle(const Duration(milliseconds: 300)); 

      // 3. Verify result elements are present
      expect(find.textContaining('Hoodie'), findsOneWidget, reason: 'Should find a product containing "Hoodie".');
      expect(find.byType(ListTile), findsWidgets, reason: 'Should find search result list tiles.');
    });

    testWidgets('Shows no products found for invalid query', (WidgetTester tester) async {
      await tester.pumpWidget(createSearchTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('OPEN SEARCH'));
      await tester.pumpAndSettle();

      // Type an unlikely query
      await tester.enterText(find.byType(TextField), 'XYZNonExistentProduct');
      await tester.pumpAndSettle(const Duration(milliseconds: 300));

      // Verify the appropriate message is shown
      expect(find.text('No products found.'), findsOneWidget);
    });

    testWidgets('Tapping back button closes search', (WidgetTester tester) async {
      await tester.pumpWidget(createSearchTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('OPEN SEARCH'));
      await tester.pumpAndSettle();

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Search should be closed, original button visible
      expect(find.text('OPEN SEARCH'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    });
  });
}