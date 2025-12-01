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
      await tester.pumpAndSettle(); // Wait for any animations

      // Verify "The UNION" logo text exists
      expect(find.textContaining('The '), findsWidgets);
      expect(find.text('UNION'), findsOneWidget);

      // Verify Category headers exist (e.g. "Clothing")
      // Note: This relies on your dummy data being loaded
      expect(find.text('Clothing'), findsOneWidget);
      expect(find.text('Merchandise'), findsOneWidget);
    });

    testWidgets('Carousel renders', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const UnionShopApp()));
      await tester.pumpAndSettle();

      // Check if carousel buttons exist
      expect(find.text('FIND OUT MORE'), findsOneWidget);
    });
  });
}