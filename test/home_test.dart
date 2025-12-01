import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/main.dart'; // Adjust path if needed
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';

// Helper to create the testable widget
Widget createTestWidget(Widget child) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ShopViewModel()),
      ChangeNotifierProvider(create: (_) => CartViewModel()),
    ],
    child: MaterialApp(
      home: child,
      // Define routes if needed for navigation tests (optional here)
      routes: {
        '/cart': (context) => const Scaffold(body: Text('Cart Page')),
      },
    ),
  );
}

void main() {
  group('HomePage Tests', () {
    testWidgets('Renders essential UI elements', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(createTestWidget(const UnionShopApp()));
      
      // Allow time for the ViewModel to load data and the ListView to build
      await tester.pumpAndSettle(); 

      // Verify "The UNION" logo text exists
      expect(find.textContaining('The '), findsWidgets);
      expect(find.text('UNION'), findsOneWidget);

      // Verify Category headers exist.
      // Since we are using a real ShopViewModel with the Repository data,
      // these categories should appear on the screen.
      // We use 'findsAtLeastNWidgets(1)' because "Clothing" might appear in the menu too?
      // Actually, standard find.text should work if it's on screen.
      // If the list is long, we might need to scroll, but usually test environments have big screens.
      
      expect(find.text('Clothing'), findsOneWidget);
      
      // If "Merchandise" is further down the list, it might be off-screen.
      // Flutter tests simulate a specific screen size.
      // Let's check for "Clothing" as it's the first item.
    });

    testWidgets('Carousel renders', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const UnionShopApp()));
      await tester.pumpAndSettle();

      // Check if carousel buttons exist
      expect(find.text('FIND OUT MORE'), findsOneWidget);
    });
  });
}