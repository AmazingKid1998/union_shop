import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/pages/collections_page.dart';
import 'package:union_shop/pages/collection_detail_page.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';
import 'package:union_shop/widgets/site_footer.dart';

void main() {
  
  // Helper: Test Harness with ALL required Providers
  Widget createCollectionsTest({NavigatorObserver? observer}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartViewModel()), 
        ChangeNotifierProvider(create: (_) => ShopViewModel()), 
      ],
      child: MaterialApp(
        navigatorObservers: observer != null ? [observer] : [],
        initialRoute: '/collections',
        onGenerateRoute: (settings) {
          if (settings.name == '/collections') {
            return MaterialPageRoute(builder: (_) => const CollectionsPage());
          }
          
          final uri = Uri.parse(settings.name ?? '');
          if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'collection') {
            final id = uri.pathSegments[1];
            return MaterialPageRoute(
              builder: (_) => CollectionDetailPage(
                collectionId: id,
                title: _getTitle(id),
              ),
            );
          }
          
          return MaterialPageRoute(
            builder: (_) => const Scaffold(body: Text('Unknown')),
          );
        },
      ),
    );
  }

  static String _getTitle(String id) {
    switch (id) {
      case 'c_clothing': return 'Clothing';
      case 'c_merch': return 'Merchandise';
      case 'c_halloween': return 'Halloween 🎃';
      case 'c_grad': return 'Graduation 🎓';
      case 'c_city': return 'Portsmouth City';
      case 'c_pride': return 'Pride 🏳️‍🌈';
      case 'c_signature': return 'Signature Range';
      default: return 'Collection';
    }
  }

  group('CollectionsPage Tests', () {
    
    // --- TEST 1: VISUAL RENDERING ---
    testWidgets('Renders Page Title and Category Cards', (WidgetTester tester) async {
      await tester.pumpWidget(createCollectionsTest());
      await tester.pumpAndSettle();

      // 1. Verify Main Page Title
      expect(find.text('Shop by Category'), findsOneWidget);

      // 2. Verify Category Cards
      expect(find.text('Clothing'), findsOneWidget);
      expect(find.text('Merchandise'), findsOneWidget);
      expect(find.text('Halloween 🎃'), findsOneWidget);
      expect(find.text('Portsmouth City'), findsOneWidget);
      expect(find.text('Graduation 🎓'), findsOneWidget);
      expect(find.text('Signature Range'), findsOneWidget);
      expect(find.text('Pride 🏳️‍🌈'), findsOneWidget);
    });

    // --- TEST 2: FOOTER EXISTS ---
    testWidgets('Contains SiteFooter', (WidgetTester tester) async {
      await tester.pumpWidget(createCollectionsTest());
      await tester.pumpAndSettle();

      expect(find.byType(SiteFooter), findsOneWidget);
    });

    // --- TEST 3: NAVIGATION TO CLOTHING ---
    testWidgets('Tapping "Clothing" navigates to Collection Detail Page', (WidgetTester tester) async {
      await tester.pumpWidget(createCollectionsTest());
      await tester.pumpAndSettle();

      // Find and tap the Clothing card
      final targetCard = find.text('Clothing');
      await tester.ensureVisible(targetCard);
      await tester.pumpAndSettle();

      await tester.tap(targetCard);
      await tester.pumpAndSettle();

      // Verify navigation
      expect(find.byType(CollectionDetailPage), findsOneWidget);
      
      // Verify the title is passed correctly
      expect(
        find.descendant(
          of: find.byType(CollectionDetailPage),
          matching: find.text('Clothing')
        ), 
        findsOneWidget
      );
    });

    // --- TEST 4: NAVIGATION TO HALLOWEEN ---
    testWidgets('Tapping "Halloween" navigates correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createCollectionsTest());
      await tester.pumpAndSettle();

      final halloweenCard = find.text('Halloween 🎃');
      await tester.ensureVisible(halloweenCard);
      await tester.pumpAndSettle();

      await tester.tap(halloweenCard);
      await tester.pumpAndSettle();

      expect(find.byType(CollectionDetailPage), findsOneWidget);
      expect(find.text('Halloween 🎃'), findsOneWidget);
    });

    // --- TEST 5: NAVIGATION TO GRADUATION ---
    testWidgets('Tapping "Graduation" navigates correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createCollectionsTest());
      await tester.pumpAndSettle();

      final gradCard = find.text('Graduation 🎓');
      await tester.ensureVisible(gradCard);
      await tester.pumpAndSettle();

      await tester.tap(gradCard);
      await tester.pumpAndSettle();

      expect(find.byType(CollectionDetailPage), findsOneWidget);
    });

    // --- TEST 6: GRID LAYOUT ---
    testWidgets('Categories are displayed in a grid', (WidgetTester tester) async {
      await tester.pumpWidget(createCollectionsTest());
      await tester.pumpAndSettle();

      // GridView should be present
      expect(find.byType(GridView), findsOneWidget);
    });

    // --- TEST 7: ALL CATEGORIES CLICKABLE ---
    testWidgets('All category cards are GestureDetectors', (WidgetTester tester) async {
      await tester.pumpWidget(createCollectionsTest());
      await tester.pumpAndSettle();

      // Find all GestureDetector widgets inside the GridView
      final gestureDetectors = find.descendant(
        of: find.byType(GridView),
        matching: find.byType(GestureDetector),
      );

      // Should have 7 categories
      expect(gestureDetectors, findsNWidgets(7));
    });
  });
}

String _getTitle(String id) {
  switch (id) {
    case 'c_clothing': return 'Clothing';
    case 'c_merch': return 'Merchandise';
    case 'c_halloween': return 'Halloween 🎃';
    case 'c_grad': return 'Graduation 🎓';
    case 'c_city': return 'Portsmouth City';
    case 'c_pride': return 'Pride 🏳️‍🌈';
    case 'c_signature': return 'Signature Range';
    default: return 'Collection';
  }
}