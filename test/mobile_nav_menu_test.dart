import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';
import 'package:union_shop/widgets/mobile_nav_menu.dart';
import 'package:union_shop/models/product.dart'; // Import the actual Product model

void main() {
  
  // Helper: Create Test Widget with Provider and Navigator observers
  Widget createNavTest({NavigatorObserver? observer}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => ShopViewModel()),
      ],
      child: MaterialApp(
        navigatorObservers: observer != null ? [observer] : [],
        home: const MobileNavMenu(),
        routes: {
          '/': (_) => const Text('Home Page'),
          '/login': (_) => const Text('Login Page'),
          '/cart': (_) => const Text('Cart Page'),
          '/sale': (_) => const Text('Sale Page'),
          '/about': (_) => const Text('About Page'),
          '/print-shack/about': (_) => const Text('PS About'),
          '/print-shack/tool': (_) => const Text('PS Tool'),
        },
        onGenerateRoute: (settings) {
          if (settings.name?.startsWith('/collection/') ?? false) {
            return MaterialPageRoute(
              builder: (_) => const Text('Collection Page'),
            );
          }
          return null;
        },
      ),
    );
  }

  group('MobileNavMenu Main Menu Tests', () {

    // --- TEST 1: INITIAL RENDER ---
    testWidgets('Renders Main Menu items correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createNavTest());
      await tester.pumpAndSettle();

      // Verify Header Logo
      expect(find.textContaining('UNION', findRichText: true), findsOneWidget);
      
      // Verify Header Icons
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);

      // Verify Menu Options
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Shop'), findsOneWidget); 
      expect(find.text('The Print Shack'), findsOneWidget); 
      expect(find.text('SALE!'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
      expect(find.text('UPSU.net'), findsOneWidget);
    });

    // --- TEST 2: CLOSE BUTTON ---
    testWidgets('Close button pops the menu', (WidgetTester tester) async {
      await tester.pumpWidget(createNavTest());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Menu should be closed (MobileNavMenu not in tree)
      expect(find.byType(MobileNavMenu), findsNothing);
    });

    // --- TEST 3: ARROW INDICATORS ---
    testWidgets('Shop and Print Shack have arrow indicators', (WidgetTester tester) async {
      await tester.pumpWidget(createNavTest());
      await tester.pumpAndSettle();

      // Should have chevron_right icons for submenus
      expect(find.byIcon(Icons.chevron_right), findsNWidgets(2));
    });
  });

  group('MobileNavMenu Shop Submenu Tests', () {

    // --- TEST 4: OPEN SHOP SUBMENU ---
    testWidgets('Tapping Shop opens Shop Submenu', (WidgetTester tester) async {
      await tester.pumpWidget(createNavTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Shop'));
      await tester.pump();

      // Verify Header Changed
      expect(find.byIcon(Icons.chevron_left), findsOneWidget); // Back Arrow

      // Verify Body Changed
      expect(find.text('Clothing'), findsOneWidget);
      expect(find.text('Merchandise'), findsOneWidget);
      expect(find.text('Halloween 🎃'), findsOneWidget);
      expect(find.text('Signature & Essential Range'), findsOneWidget);
      expect(find.text('Portsmouth City Collection'), findsOneWidget);
      expect(find.text('Pride Collection 🏳️‍🌈'), findsOneWidget);
      expect(find.text('Graduation 🎓'), findsOneWidget);
      
      // Verify Main Menu items are GONE
      expect(find.text('SALE!'), findsNothing); 
    });

    // --- TEST 5: BACK FROM SHOP ---
    testWidgets('Back arrow returns to Main Menu from Shop', (WidgetTester tester) async {
      await tester.pumpWidget(createNavTest());
      await tester.pumpAndSettle();

      // Go to Shop
      await tester.tap(find.text('Shop'));
      await tester.pump();

      // Verify we are in Shop
      expect(find.text('Clothing'), findsOneWidget);

      // Tap Back Arrow
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pump();

      // Verify we are back at Main
      expect(find.text('SALE!'), findsOneWidget);
      expect(find.text('Clothing'), findsNothing);
    });

    // --- TEST 6: SHOP NAVIGATION ---
    testWidgets('Tapping Clothing navigates to collection', (WidgetTester tester) async {
      await tester.pumpWidget(createNavTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Shop'));
      await tester.pump();

      await tester.tap(find.text('Clothing'));
      await tester.pumpAndSettle();

      expect(find.text('Collection Page'), findsOneWidget);
    });
  });

  group('MobileNavMenu Print Shack Submenu Tests', () {

    // --- TEST 7: OPEN PRINT SHACK SUBMENU ---
    testWidgets('Tapping Print Shack opens submenu', (WidgetTester tester) async {
      await tester.pumpWidget(createNavTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('The Print Shack'));
      await tester.pump();

      // Verify submenu items
      expect(find.text('About'), findsOneWidget);
      expect(find.text('Personalisation'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
    });

    // --- TEST 8: PRINT SHACK NAVIGATION ---
    testWidgets('Navigate to Personalisation tool', (WidgetTester tester) async {
      await tester.pumpWidget(createNavTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('The Print Shack'));
      await tester.pump();

      await tester.tap(find.text('Personalisation'));
      await tester.pumpAndSettle();

      expect(find.text('PS Tool'), findsOneWidget);
    });

    // --- TEST 9: PRINT SHACK ABOUT ---
    testWidgets('Navigate to Print Shack About', (WidgetTester tester) async {
      await tester.pumpWidget(createNavTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('The Print Shack'));
      await tester.pump();

      await tester.tap(find.text('About'));
      await tester.pumpAndSettle();

      expect(find.text('PS About'), findsOneWidget);
    });
  });

  group('MobileNavMenu External Navigation Tests', () {

    // --- TEST 10: LOGIN ---
    testWidgets('Tapping Login Icon pushes /login route', (WidgetTester tester) async {
      await tester.pumpWidget(createNavTest());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();

      expect(find.text('Login Page'), findsOneWidget);
    });

    // --- TEST 11: CART ---
    testWidgets('Tapping Cart Icon pushes /cart route', (WidgetTester tester) async {
      await tester.pumpWidget(createNavTest());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Cart Page'), findsOneWidget);
    });

    // --- TEST 12: SALE ---
    testWidgets('Tapping SALE navigates correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createNavTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('SALE!'));
      await tester.pumpAndSettle();

      expect(find.text('Sale Page'), findsOneWidget);
    });

    // --- TEST 13: ABOUT ---
    testWidgets('Tapping About navigates correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createNavTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('About'));
      await tester.pumpAndSettle();

      expect(find.text('About Page'), findsOneWidget);
    });
  });

  group('MobileNavMenu Cart Badge Tests', () {

    testWidgets('Cart badge shows count when items in cart', (WidgetTester tester) async {
      final cart = CartViewModel();
      
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: cart),
            ChangeNotifierProvider(create: (_) => ShopViewModel()),
          ],
          child: const MaterialApp(home: MobileNavMenu()),
        ),
      );
      await tester.pumpAndSettle();

      // Add items using the actual Product model from union_shop/models/product.dart
      cart.add(
        Product(
          id: 'test',
          title: 'Test',
          price: 10,
          image: 'img.jpg',
          description: 'desc',
          collectionIds: ['c_test'],
        ),
      );
      cart.add(
        Product(
          id: 'test2',
          title: 'Test2',
          price: 15,
          image: 'img.jpg',
          description: 'desc',
          collectionIds: ['c_test'],
        ),
      );
      
      await tester.pumpAndSettle();

      expect(find.text('2'), findsOneWidget);
    });
  });
}