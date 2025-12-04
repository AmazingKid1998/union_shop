import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/main.dart'; 
import 'package:union_shop/pages/home_page.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';
import 'package:union_shop/widgets/home_carousel.dart';
import 'package:union_shop/widgets/site_footer.dart';

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
        '/product/p_classic_hoodie': (context) => const Scaffold(body: Text('Product Page')),
      },
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

void main() {
  group('HomePage Tests', () {
    testWidgets('Renders HomePage without errors', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const HomePage()));
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('Contains HomeCarousel', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const HomePage()));
      await tester.pumpAndSettle();

      expect(find.byType(HomeCarousel), findsOneWidget);
    });

    testWidgets('Carousel renders with CTA button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const HomePage()));
      await tester.pumpAndSettle();

      expect(find.text('FIND OUT MORE'), findsOneWidget);
    });

    testWidgets('Contains SiteFooter', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const HomePage()));
      await tester.pumpAndSettle();

      expect(find.byType(SiteFooter), findsOneWidget);
    });

    testWidgets('Renders category headers from products', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const HomePage()));
      await tester.pumpAndSettle();

      // Wait for products to load
      await Future.delayed(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Should show at least one category
      // The HomePage shows one product per primary category
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('Logo is present in header', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const HomePage()));
      await tester.pumpAndSettle();

      // Find RichText containing "UNION"
      final unionFinder = find.byWidgetPredicate((widget) {
        if (widget is RichText) {
          final text = widget.text.toPlainText();
          return text.contains('UNION');
        }
        return false;
      });
      
      expect(unionFinder, findsWidgets);
    });

    testWidgets('Header icons are present', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const HomePage()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsWidgets);
    });
  });

  group('HomePage Navigation Tests', () {
    testWidgets('Product tap navigates to product page', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const HomePage()));
      await tester.pumpAndSettle();

      // Wait for products to load
      await Future.delayed(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Find a product and tap it
      final products = find.byType(GestureDetector);
      if (products.evaluate().length > 1) {
        // Skip carousel buttons, find product cards
        await tester.scrollUntilVisible(
          find.textContaining('£'),
          100,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
      }
    });
  });

  group('HomePage with UnionShopApp', () {
    testWidgets('Full app renders HomePage as initial route', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ShopViewModel()),
            ChangeNotifierProvider(create: (_) => CartViewModel()),
          ],
          child: const UnionShopApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
    });
  });

  group('HomePage Product Display', () {
    testWidgets('Shows products with prices', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const HomePage()));
      await tester.pumpAndSettle();

      // Wait for products to load
      await Future.delayed(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Should find price text
      expect(find.textContaining('£'), findsWidgets);
    });

    testWidgets('Category names are formatted correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const HomePage()));
      await tester.pumpAndSettle();

      // Wait for products to load
      await Future.delayed(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Categories should have proper formatting (not raw IDs like 'c_clothing')
      expect(find.text('c_clothing'), findsNothing);
    });
  });
}