import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/pages/collections_page.dart';
import 'package:union_shop/pages/collection_detail_page.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';
import 'package:union_shop/widgets/site_footer.dart';

void main() {
  
  // 1. HELPER: Test Harness with ALL required Providers
  Widget createCollectionsTest(NavigatorObserver observer) {
    return MultiProvider(
      providers: [
        // Required by SiteHeader
        ChangeNotifierProvider(create: (_) => CartViewModel()), 
        // Required by CollectionDetailPage (The destination we navigate to)
        ChangeNotifierProvider(create: (_) => ShopViewModel()), 
      ],
      child: MaterialApp(
        navigatorObservers: [observer], // Attach spy to watch navigation
        home: const CollectionsPage(),
      ),
    );
  }

  group('CollectionsPage Tests', () {
    
    // --- TEST 1: VISUAL RENDERING ---
    testWidgets('Renders Page Title and Category Cards', (WidgetTester tester) async {
      await tester.pumpWidget(createCollectionsTest(NavigatorObserver()));

      // 1. Verify Main Page Title
      expect(find.text('Shop by Category'), findsOneWidget);

      // 2. Verify Category Cards (Checking a few key ones)
      expect(find.text('Clothing'), findsOneWidget);
      expect(find.text('Merchandise'), findsOneWidget);
      expect(find.text('Halloween 🎃'), findsOneWidget); // Checks special characters
      expect(find.text('Portsmouth City'), findsOneWidget);
      expect(find.text('Graduation 🎓'), findsOneWidget);

      // 3. Verify Footer exists (Scroll to find it)
      expect(find.byType(SiteFooter), findsOneWidget);
    });

    // --- TEST 2: NAVIGATION INTEGRATION ---
    testWidgets('Tapping "Clothing" navigates to Collection Detail Page', (WidgetTester tester) async {
      // Setup Navigation Spy
      final mockObserver = NavigatorObserver();
      
      await tester.pumpWidget(createCollectionsTest(mockObserver));

      // 1. Find the Card
      final targetCard = find.text('Clothing');
      
      // 2. Scroll to it (Crucial for GridViews on small test screens)
      await tester.ensureVisible(targetCard);
      await tester.pumpAndSettle();

      // 3. Tap the card
      await tester.tap(targetCard);
      
      // 4. Wait for the push animation
      await tester.pumpAndSettle();

      // 5. VERIFY NAVIGATION
      // Check if the destination page is now in the tree
      expect(find.byType(CollectionDetailPage), findsOneWidget);
      
      // 6. VERIFY ARGUMENTS PASSED
      // The destination page should display the title "Clothing" at the top
      // We look for the large bold header inside CollectionDetailPage
      expect(
        find.descendant(
          of: find.byType(CollectionDetailPage),
          matching: find.text('Clothing')
        ), 
        findsOneWidget
      );
    });

    testWidgets('Tapping "Halloween" navigates correctly', (WidgetTester tester) async {
      final mockObserver = NavigatorObserver();
      await tester.pumpWidget(createCollectionsTest(mockObserver));

      final halloweenCard = find.text('Halloween 🎃');
      
      await tester.ensureVisible(halloweenCard);
      await tester.pumpAndSettle();

      await tester.tap(halloweenCard);
      await tester.pumpAndSettle();

      expect(find.byType(CollectionDetailPage), findsOneWidget);
      expect(find.text('Halloween 🎃'), findsOneWidget);
    });
  });
}