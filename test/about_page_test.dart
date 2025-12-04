import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/pages/about_page.dart';
import 'package:union_shop/pages/print_shack_page.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';

void main() {
  
  // Helper: AboutPage includes SiteHeader, which needs CartViewModel and ShopViewModel
  Widget createTestWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => ShopViewModel()),
      ],
      child: const MaterialApp(
        home: AboutPage(),
      ),
    );
  }

  group('AboutPage Tests', () {
    
    // --- TEST 1: VISUAL CONTENT ---
    testWidgets('Renders all text paragraphs correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 1. Verify Title
      expect(find.text('About us'), findsOneWidget);

      // 2. Verify Standard Text
      expect(find.text('Welcome to the Union Shop!'), findsOneWidget);
      expect(find.textContaining('online purchases are available'), findsOneWidget);
      expect(find.textContaining('hello@upsu.net'), findsOneWidget);
      expect(find.text('Happy shopping!'), findsOneWidget);
      
      // 3. Verify Signature
      expect(find.text('The Union Shop & Reception Team'), findsOneWidget);
    });

    // --- TEST 2: RICH TEXT LINK ---
    testWidgets('Contains personalisation service link text', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the RichText widget containing our link
      final richTextFinder = find.byWidgetPredicate((widget) => 
        widget is RichText && 
        widget.text.toPlainText().contains('personalisation service')
      );
      expect(richTextFinder, findsOneWidget);
    });

    // --- TEST 3: NAVIGATION FROM LINK ---
    testWidgets('Tapping "personalisation service" navigates to Print Shack', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the RichText widget containing our link
      final richTextFinder = find.byWidgetPredicate((widget) => 
        widget is RichText && 
        widget.text.toPlainText().contains('personalisation service')
      );
      expect(richTextFinder, findsOneWidget);

      // Get the RichText widget and find the tap recognizer
      final richTextWidget = tester.widget<RichText>(richTextFinder);
      final textSpan = richTextWidget.text as TextSpan;
      
      // Find the child span with the recognizer
      final linkSpan = textSpan.children!.firstWhere(
        (span) => span is TextSpan && span.text == 'personalisation service'
      ) as TextSpan;

      // Fire the tap event manually
      (linkSpan.recognizer as TapGestureRecognizer).onTap!();
      
      // Wait for navigation animation
      await tester.pumpAndSettle();

      // Verify we are now on the Print Shack Page
      expect(find.byType(PrintShackPage), findsOneWidget);
    });

    // --- TEST 4: FOOTER PRESENCE ---
    testWidgets('Contains SiteFooter', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Scroll to find footer
      await tester.scrollUntilVisible(
        find.text('Opening Hours'),
        500,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Opening Hours'), findsOneWidget);
    });

    // --- TEST 5: HEADER PRESENCE ---
    testWidgets('Contains SiteHeader', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should have header icons
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    });

    // --- TEST 6: STYLING ---
    testWidgets('Title has correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final titleFinder = find.text('About us');
      expect(titleFinder, findsOneWidget);

      final Text titleWidget = tester.widget<Text>(titleFinder);
      expect(titleWidget.style?.fontSize, 32);
      expect(titleWidget.style?.fontWeight, FontWeight.bold);
    });
  });
}