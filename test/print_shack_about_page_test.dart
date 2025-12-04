import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/pages/print_shack_about_page.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';

void main() {
  
  Widget createAboutPageTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => ShopViewModel()),
      ],
      child: const MaterialApp(
        home: PrintShackAboutPage(),
      ),
    );
  }

  group('PrintShackAboutPage Visual Tests', () {
    
    testWidgets('Renders page title', (WidgetTester tester) async {
      await tester.pumpWidget(createAboutPageTest());
      await tester.pumpAndSettle();

      expect(find.text('The Union Print Shack'), findsOneWidget);
    });

    testWidgets('Renders all section headers', (WidgetTester tester) async {
      await tester.pumpWidget(createAboutPageTest());
      await tester.pumpAndSettle();

      // Scroll to see all sections
      final scrollable = find.byType(Scrollable).first;

      await tester.scrollUntilVisible(
        find.text('Make It Yours at The Union Print Shack'),
        100,
        scrollable: scrollable,
      );
      expect(find.text('Make It Yours at The Union Print Shack'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Uni Gear or Your Gear - We\'ll Personalise It'),
        100,
        scrollable: scrollable,
      );
      expect(find.text('Uni Gear or Your Gear - We\'ll Personalise It'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Simple Pricing, No Surprises'),
        100,
        scrollable: scrollable,
      );
      expect(find.text('Simple Pricing, No Surprises'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Personalisation Terms & Conditions'),
        100,
        scrollable: scrollable,
      );
      expect(find.text('Personalisation Terms & Conditions'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Ready to Make It Yours?'),
        100,
        scrollable: scrollable,
      );
      expect(find.text('Ready to Make It Yours?'), findsOneWidget);
    });

    testWidgets('Contains pricing information', (WidgetTester tester) async {
      await tester.pumpWidget(createAboutPageTest());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.textContaining('£3 for one line'),
        100,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.textContaining('£3'), findsWidgets);
      expect(find.textContaining('£5'), findsWidgets);
    });

    testWidgets('Contains turnaround time information', (WidgetTester tester) async {
      await tester.pumpWidget(createAboutPageTest());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.textContaining('three working days'),
        100,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.textContaining('three working days'), findsOneWidget);
    });

    testWidgets('Contains terms and conditions notice', (WidgetTester tester) async {
      await tester.pumpWidget(createAboutPageTest());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.textContaining('Refunds are not provided'),
        100,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.textContaining('Refunds are not provided'), findsOneWidget);
    });

    testWidgets('Contains banner image placeholder', (WidgetTester tester) async {
      await tester.pumpWidget(createAboutPageTest());
      await tester.pumpAndSettle();

      // Image.asset widget should be present
      expect(find.byType(Image), findsWidgets);
    });
  });

  group('PrintShackAboutPage Layout Tests', () {

    testWidgets('Uses SingleChildScrollView', (WidgetTester tester) async {
      await tester.pumpWidget(createAboutPageTest());
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('Content is properly padded', (WidgetTester tester) async {
      await tester.pumpWidget(createAboutPageTest());
      await tester.pumpAndSettle();

      // Multiple Padding widgets should exist
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('Title has correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(createAboutPageTest());
      await tester.pumpAndSettle();

      final titleFinder = find.text('The Union Print Shack');
      expect(titleFinder, findsOneWidget);

      final Text titleWidget = tester.widget<Text>(titleFinder);
      expect(titleWidget.style?.fontSize, 32);
      expect(titleWidget.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('Contains SiteFooter', (WidgetTester tester) async {
      await tester.pumpWidget(createAboutPageTest());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Opening Hours'),
        500,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Opening Hours'), findsOneWidget);
    });

    testWidgets('Contains SiteHeader', (WidgetTester tester) async {
      await tester.pumpWidget(createAboutPageTest());
      await tester.pumpAndSettle();

      // Header icons should be present
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsWidgets);
    });
  });

  group('PrintShackAboutPage Content Tests', () {

    testWidgets('Make It Yours section has correct content', (WidgetTester tester) async {
      await tester.pumpWidget(createAboutPageTest());
      await tester.pumpAndSettle();

      expect(find.textContaining('heat-pressed'), findsOneWidget);
    });

    testWidgets('Uni Gear section mentions both options', (WidgetTester tester) async {
      await tester.pumpWidget(createAboutPageTest());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.textContaining('official uni-branded'),
        100,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.textContaining('official uni-branded'), findsOneWidget);
      expect(find.textContaining('your own items'), findsOneWidget);
    });

    testWidgets('Pricing section has all price points', (WidgetTester tester) async {
      await tester.pumpWidget(createAboutPageTest());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.textContaining('one line of text'),
        100,
        scrollable: find.byType(Scrollable).first,
      );

      // Check various pricing mentions
      expect(find.textContaining('chest logo'), findsOneWidget);
      expect(find.textContaining('back logo'), findsOneWidget);
    });

    testWidgets('Call to action section exists', (WidgetTester tester) async {
      await tester.pumpWidget(createAboutPageTest());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.textContaining('Pop in or get in touch'),
        100,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.textContaining('Pop in or get in touch'), findsOneWidget);
    });
  });
}