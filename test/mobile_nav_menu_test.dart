import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/widgets/mobile_nav_menu.dart'; // Adjust path

void main() {
  
  // 1. HELPER: Create Test Widget with Provider and Navigator observers
  // We need to 'spy' on the Navigator to ensure it pushes the right routes
  Widget createNavTest(NavigatorObserver observer) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartViewModel()), // Required for the cart icon count
      ],
      child: MaterialApp(
        navigatorObservers: [observer], // Attach spy
        home: const MobileNavMenu(),
        routes: {
          '/login': (_) => const Text('Login Page'),
          '/cart': (_) => const Text('Cart Page'),
          '/sale': (_) => const Text('Sale Page'),
          '/about': (_) => const Text('About Page'),
          '/print-shack/about': (_) => const Text('PS About'),
          '/print-shack/tool': (_) => const Text('PS Tool'),
        },
      ),
    );
  }

  group('MobileNavMenu Logic', () {
    late NavigatorObserver mockObserver;

    setUp(() {
      mockObserver = NavigatorObserver();
    });

    // --- TEST 1: INITIAL RENDER ---
    testWidgets('Renders Main Menu items correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createNavTest(mockObserver));

      // Verify Header
      // FIX: Use textContaining because 'UNION' is part of a larger RichText string "The UNION"
      expect(find.textContaining('UNION', findRichText: true), findsOneWidget);
      
      expect(find.byIcon(Icons.person_outline), findsOneWidget);

      // Verify Menu Options
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Shop'), findsOneWidget); 
      expect(find.text('The Print Shack'), findsOneWidget); 
      expect(find.text('SALE!'), findsOneWidget);
    });

    // --- TEST 2: INTERNAL NAVIGATION (Go to Shop Submenu) ---
    testWidgets('Tapping Shop opens Shop Submenu', (WidgetTester tester) async {
      await tester.pumpWidget(createNavTest(mockObserver));

      // 1. Find and Tap 'Shop'
      final shopItem = find.text('Shop');
      await tester.tap(shopItem);
      await tester.pump(); // Rebuild UI (setState)

      // 2. Verify Header Changed
      expect(find.text('Shop'), findsOneWidget); // Submenu Title
      expect(find.byIcon(Icons.chevron_left), findsOneWidget); // Back Arrow

      // 3. Verify Body Changed
      expect(find.text('Clothing'), findsOneWidget);
      expect(find.text('Merchandise'), findsOneWidget);
      
      // 4. Verify Main Menu items are GONE
      expect(find.text('SALE!'), findsNothing); 
    });

    // --- TEST 3: BACK NAVIGATION (Submenu -> Main) ---
    testWidgets('Back arrow returns to Main Menu', (WidgetTester tester) async {
      await tester.pumpWidget(createNavTest(mockObserver));

      // 1. Go to Shop
      await tester.tap(find.text('Shop'));
      await tester.pump();

      // 2. Verify we are in Shop
      expect(find.text('Clothing'), findsOneWidget);

      // 3. Tap Back Arrow (In Header)
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pump();

      // 4. Verify we are back at Main
      expect(find.text('SALE!'), findsOneWidget);
      expect(find.text('Clothing'), findsNothing);
    });

    // --- TEST 4: EXTERNAL NAVIGATION (Link to Route) ---
    testWidgets('Tapping Login Icon pushes /login route', (WidgetTester tester) async {
      await tester.pumpWidget(createNavTest(mockObserver));

      // 1. Tap Login Icon
      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();

      // 2. Verify New Page is visible
      expect(find.text('Login Page'), findsOneWidget);
    });
    
    // --- TEST 5: COMPLEX NAVIGATION (Deep Link) ---
    testWidgets('Navigate Deep: Print Shack -> Personalisation', (WidgetTester tester) async {
      await tester.pumpWidget(createNavTest(mockObserver));

      // 1. Open Print Shack Submenu
      await tester.tap(find.text('The Print Shack'));
      await tester.pump();

      // 2. Find 'Personalisation' item
      final link = find.text('Personalisation');
      expect(link, findsOneWidget);

      // 3. Tap it
      await tester.tap(link);
      await tester.pumpAndSettle();

      // 4. Verify Navigation to '/print-shack/tool'
      expect(find.text('PS Tool'), findsOneWidget);
    });
  });
}