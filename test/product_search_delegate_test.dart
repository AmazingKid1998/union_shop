import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/widgets/product_search_delegate.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';

void main() {
  
  // Helper: Simple harness
  Widget createSearchTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShopViewModel()),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
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
          if (settings.name?.startsWith('/product/') ?? false) {
            return MaterialPageRoute(
              builder: (_) => const Scaffold(body: Text('Product Page')),
            );
          }
          return null;
        },
      ),
    );
  }

  group('ProductSearchDelegate Basic Tests', () {
    
    testWidgets('Opens search interface', (WidgetTester tester) async {
      await tester.pumpWidget(createSearchTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('OPEN SEARCH'));
      await tester.pumpAndSettle();

      // Search interface should have a TextField
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('Shows prompt text when query is empty', (WidgetTester tester) async {
      await tester.pumpWidget(createSearchTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('OPEN SEARCH'));
      await tester.pumpAndSettle();

      expect(find.text('Search for products...'), findsOneWidget);
    });

    testWidgets('Back button closes search', (WidgetTester tester) async {
      await tester.pumpWidget(createSearchTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('OPEN SEARCH'));
      await tester.pumpAndSettle();

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Search should be closed, original button visible
      expect(find.text('OPEN SEARCH'), findsOneWidget);
    });
  });

  group('ProductSearchDelegate Query Tests', () {

    testWidgets('Filters products based on query', (WidgetTester tester) async {
      await tester.pumpWidget(createSearchTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('OPEN SEARCH'));
      await tester.pumpAndSettle();

      // Type a search query
      await tester.enterText(find.byType(TextField), 'Hoodie');
      await tester.pumpAndSettle();

      // Should find products matching "Hoodie"
      expect(find.textContaining('Hoodie'), findsWidgets);
    });

    testWidgets('Shows no products found for invalid query', (WidgetTester tester) async {
      await tester.pumpWidget(createSearchTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('OPEN SEARCH'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'XYZNOTFOUND12345');
      await tester.pumpAndSettle();

      expect(find.text('No products found.'), findsOneWidget);
    });

    testWidgets('Search is case insensitive', (WidgetTester tester) async {
      await tester.pumpWidget(createSearchTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('OPEN SEARCH'));
      await tester.pumpAndSettle();

      // Search with lowercase
      await tester.enterText(find.byType(TextField), 'hoodie');
      await tester.pumpAndSettle();

      expect(find.textContaining('Hoodie'), findsWidgets);
    });

    testWidgets('Clear button resets the query', (WidgetTester tester) async {
      await tester.pumpWidget(createSearchTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('OPEN SEARCH'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Hoodie');
      await tester.pumpAndSettle();

      // Tap Clear
      final clearBtn = find.byIcon(Icons.clear);
      await tester.tap(clearBtn);
      await tester.pumpAndSettle();

      // Query should be empty, showing prompt
      expect(find.text('Search for products...'), findsOneWidget);
    });
  });

  group('ProductSearchDelegate Results Display Tests', () {

    testWidgets('Results show product titles', (WidgetTester tester) async {
      await tester.pumpWidget(createSearchTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('OPEN SEARCH'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Classic');
      await tester.pumpAndSettle();

      expect(find.textContaining('Classic'), findsWidgets);
    });

    testWidgets('Results show product prices', (WidgetTester tester) async {
      await tester.pumpWidget(createSearchTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('OPEN SEARCH'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Hoodie');
      await tester.pumpAndSettle();

      // Should show price formatting
      expect(find.textContaining('£'), findsWidgets);
    });

    testWidgets('Results show as ListTile', (WidgetTester tester) async {
      await tester.pumpWidget(createSearchTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('OPEN SEARCH'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Tee');
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsWidgets);
    });
  });

  group('ProductSearchDelegate Partial Match Tests', () {

    testWidgets('Partial matches work', (WidgetTester tester) async {
      await tester.pumpWidget(createSearchTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('OPEN SEARCH'));
      await tester.pumpAndSettle();

      // Search for partial word
      await tester.enterText(find.byType(TextField), 'Grad');
      await tester.pumpAndSettle();

      expect(find.textContaining('Graduation'), findsWidgets);
    });

    testWidgets('Single character search works', (WidgetTester tester) async {
      await tester.pumpWidget(createSearchTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('OPEN SEARCH'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'P');
      await tester.pumpAndSettle();

      // Should find products with 'P' in title
      expect(find.byType(ListTile), findsWidgets);
    });
  });

  group('ProductSearchDelegate Action Tests', () {

    testWidgets('Clear icon only shows when query is not empty', (WidgetTester tester) async {
      await tester.pumpWidget(createSearchTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('OPEN SEARCH'));
      await tester.pumpAndSettle();

      // Initially no clear button (or it's not doing anything meaningful)
      expect(find.byIcon(Icons.clear), findsNothing);

      // Type something
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pumpAndSettle();

      // Now clear button should be visible
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });
  });
}