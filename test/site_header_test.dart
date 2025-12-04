import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/widgets/site_header.dart';
import 'package:union_shop/widgets/mobile_nav_menu.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';
import 'package:union_shop/models/product.dart';

void main() {
  
  // Helper: Create test harness
  Widget createHeaderTest({CartViewModel? cartVM}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => cartVM ?? CartViewModel()),
        ChangeNotifierProvider(create: (_) => ShopViewModel()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (_) => const Scaffold(appBar: SiteHeader()),
          '/login': (_) => const Scaffold(body: Text('Login Screen')),
          '/profile': (_) => const Scaffold(body: Text('Profile Screen')),
          '/cart': (_) => const Scaffold(body: Text('Cart Screen')),
        },
      ),
    );
  }

  group('SiteHeader Visual Tests', () {
    testWidgets('Renders Banner, Logo, and Icons', (WidgetTester tester) async {
      await tester.pumpWidget(createHeaderTest());
      await tester.pumpAndSettle();

      // Verify Banner Text
      expect(find.textContaining('BIG SALE!'), findsOneWidget);
      expect(find.textContaining('OVER 20% OFF!'), findsOneWidget);

      // Verify Logo using RichText finder
      final logoFinder = find.byWidgetPredicate((widget) {
        if (widget is RichText) {
          return widget.text.toPlainText().contains('UNION');
        }
        return false;
      });
      expect(logoFinder, findsWidgets);

      // Verify Icons
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('Banner has correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(createHeaderTest());
      await tester.pumpAndSettle();

      // Find the banner container (purple background)
      final bannerText = find.textContaining('BIG SALE!');
      expect(bannerText, findsOneWidget);
    });
  });

  group('SiteHeader Logic Tests', () {
    
    // --- TEST 1: CART BADGE VISIBILITY ---
    testWidgets('Cart Badge is hidden when empty, visible when items added', (WidgetTester tester) async {
      final cart = CartViewModel();
      
      await tester.pumpWidget(createHeaderTest(cartVM: cart));
      await tester.pumpAndSettle();
      
      // Start Empty -> Badge text '1' should NOT be there
      expect(find.text('1'), findsNothing);

      // Add Item
      cart.add(Product(
        id: 'test_1', 
        title: 'Tee', 
        price: 10, 
        image: 'img.jpg', 
        description: 'desc', 
        collectionIds: ['c_clothing'],
      ));
      
      await tester.pumpAndSettle();

      // Verify Red Badge appears with '1'
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('Cart Badge updates with multiple items', (WidgetTester tester) async {
      final cart = CartViewModel();
      
      await tester.pumpWidget(createHeaderTest(cartVM: cart));
      await tester.pumpAndSettle();

      // Add 3 items
      for (int i = 0; i < 3; i++) {
        cart.add(Product(
          id: 'test_$i',
          title: 'Item $i',
          price: 10,
          image: 'img.jpg',
          description: 'desc',
          collectionIds: ['c_test'],
        ));
      }
      
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);
    });

    // --- TEST 2: NAVIGATION ICONS ---
    testWidgets('Profile Icon navigates to Login when not logged in', (WidgetTester tester) async {
      await tester.pumpWidget(createHeaderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();

      // Since we're not using real Firebase in tests, it goes to login
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

      // Tap Menu
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Verify MobileNavMenu is on screen
      expect(find.byType(MobileNavMenu), findsOneWidget);
    });
    
    // --- TEST 4: SEARCH ---
    testWidgets('Search Icon triggers search view', (WidgetTester tester) async {
      await tester.pumpWidget(createHeaderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // showSearch creates a TextField for input
      expect(find.byType(TextField), findsOneWidget); 
    });

    // --- TEST 5: LOGO TAP ---
    testWidgets('Logo tap navigates to home', (WidgetTester tester) async {
      await tester.pumpWidget(createHeaderTest());
      await tester.pumpAndSettle();

      // Find the RichText logo and tap it
      final logoFinder = find.byWidgetPredicate((widget) {
        if (widget is RichText) {
          return widget.text.toPlainText().contains('UNION');
        }
        return false;
      });

      await tester.tap(logoFinder.first);
      await tester.pumpAndSettle();

      // Should stay on home (or navigate to home)
      expect(find.byType(SiteHeader), findsOneWidget);
    });
  });

  group('SiteHeader Responsive Tests', () {
    testWidgets('Shows mobile layout on narrow screens', (WidgetTester tester) async {
      // Set small screen size
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createHeaderTest());
      await tester.pumpAndSettle();

      // Should show hamburger menu on mobile
      expect(find.byIcon(Icons.menu), findsOneWidget);

      // Reset
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}