import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/widgets/site_header.dart';
import 'package:union_shop/widgets/mobile_nav_menu.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/models/product.dart';

void main() {
  
  // --- 1. THE FIX IS IN THIS HELPER ---
  Widget createHeaderTest({CartViewModel? cartVM}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => cartVM ?? CartViewModel()),
      ],
      child: MaterialApp(
        // FIX: Remove 'home'. Use 'initialRoute' instead.
        initialRoute: '/', 
        routes: {
          // We define the Widget Under Test (SiteHeader) as the root route ('/')
          // This fixes the redundancy error and allows the Logo to "navigate home" safely.
          '/': (_) => const Scaffold(appBar: SiteHeader()),
          
          // Dummy routes for other pages
          '/login': (_) => const Scaffold(body: Text('Login Screen')),
          '/cart': (_) => const Scaffold(body: Text('Cart Screen')),
        },
      ),
    );
  }

  group('SiteHeader Visual Tests', () {
    testWidgets('Renders Banner, Logo, and Icons', (WidgetTester tester) async {
      await tester.pumpWidget(createHeaderTest());
      await tester.pumpAndSettle(); // Wait for layout

      // 1. Verify Banner Text
      expect(find.textContaining('BIG SALE!'), findsOneWidget);
      expect(find.textContaining('OVER 20% OFF!'), findsOneWidget);

      // 2. Verify Logo (Using RichText finder logic)
      // Note: We search for the full span text "The UNION" just to be safe with how RichText renders
      expect(find.text('The UNION', findRichText: true), findsOneWidget);

      // 3. Verify Icons
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });
  });

  group('SiteHeader Logic Tests', () {
    
    // --- TEST 1: CART BADGE VISIBILITY ---
    testWidgets('Cart Badge is hidden when empty, visible when items added', (WidgetTester tester) async {
      final cart = CartViewModel();
      
      await tester.pumpWidget(createHeaderTest(cartVM: cart));
      await tester.pumpAndSettle();
      
      // A. Start Empty -> Badge text '1' should NOT be there
      expect(find.text('1'), findsNothing);

      // B. Add Item
      cart.add(Product(
        id: 'test_1', 
        title: 'Tee', 
        price: 10, 
        image: 'img.jpg', 
        description: 'desc', 
        collectionId: 'col'
      ));
      
      await tester.pumpAndSettle(); // Trigger Rebuild

      // Verify Red Badge appears with '1'
      expect(find.text('1'), findsOneWidget);
    });

    // --- TEST 2: NAVIGATION ICONS ---
    testWidgets('Profile Icon navigates to Login', (WidgetTester tester) async {
      await tester.pumpWidget(createHeaderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle(); // Wait for navigation animation

      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('Cart Icon navigates to Cart', (WidgetTester tester) async {
      await tester.pumpWidget(createHeaderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Cart Screen'), findsOneWidget);
    });

    // --- TEST 3: HAMBURGER MENU ---
    testWidgets('Hamburger Menu opens MobileNavMenu', (WidgetTester tester) async {
      await tester.pumpWidget(createHeaderTest());
      await tester.pumpAndSettle();

      // 1. Tap Menu
      await tester.tap(find.byIcon(Icons.menu));
      
      // 2. Wait for SlideTransition
      await tester.pumpAndSettle();

      // 3. Verify MobileNavMenu is on screen
      expect(find.byType(MobileNavMenu), findsOneWidget);
    });
    
    // --- TEST 4: SEARCH (Smoke Test) ---
    testWidgets('Search Icon triggers search view', (WidgetTester tester) async {
      await tester.pumpWidget(createHeaderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // showSearch creates a specific route with a TextField for input
      expect(find.byType(TextField), findsOneWidget); 
    });
  });
}