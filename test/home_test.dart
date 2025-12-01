import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/main.dart'; 
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';

Widget createTestWidget(Widget child) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ShopViewModel()),
      ChangeNotifierProvider(create: (_) => CartViewModel()),
    ],
    child: MaterialApp(
      home: child,
      routes: {
        '/cart': (context) => const Scaffold(body: Text('Cart Page')),
      },
    ),
  );
}

void main() {
  group('HomePage Tests', () {
    testWidgets('Renders essential UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const UnionShopApp()));
      await tester.pumpAndSettle(); 

      // FIX: Finding RichText is tricky.
      // Option 1: Find by Type (Simplest)
      expect(find.byType(RichText), findsWidgets);

      // Option 2: Find the specific text spans
      // We search for a RichText widget that contains our specific string
      final unionFinder = find.byWidgetPredicate((widget) {
        if (widget is RichText) {
          final span = widget.text as TextSpan;
          // Check if any child span has "UNION"
          return span.children?.any((s) => (s as TextSpan).text == 'UNION') ?? false;
        }
        return false;
      });
      
      expect(unionFinder, findsOneWidget);

      // Verify Category headers exist (e.g., Clothing)
      // Note: Ensure your ProductRepository actually returns data in the test environment!
      // If it fails, it might be because images are failing to load in test.
      expect(find.text('Clothing'), findsOneWidget); 
    });

    testWidgets('Carousel renders', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const UnionShopApp()));
      await tester.pumpAndSettle();

      expect(find.text('FIND OUT MORE'), findsOneWidget);
    });
  });
}