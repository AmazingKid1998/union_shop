import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/pages/about_page.dart';
import 'package:union_shop/pages/print_shack_page.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';

void main() {
  
  // Helper: AboutPage includes SiteHeader, which likely needs CartViewModel.
  // We wrap it to prevent "ProviderNotFoundException".
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
    
    // --- TEST 1: VISUAL CONTENT (BOOSTS COVERAGE) ---
    testWidgets('Renders all text paragraphs correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // 1. Verify Title
      expect(find.text('About us'), findsOneWidget);

      // 2. Verify Standard Text
      expect(find.text('Welcome to the Union Shop!'), findsOneWidget);
      expect(find.textContaining('online purchases are available'), findsOneWidget);
      expect(find.textContaining('hello@upsu.net'), findsOneWidget);
      
      // 3. Verify Signature
      expect(find.text('The Union Shop & Reception Team'), findsOneWidget);
    });

    // --- TEST 2: RICH TEXT LINK (THE TRICKY PART) ---
    testWidgets('Tapping "personalisation service" navigates to Print Shack', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // 1. Find the RichText widget containing our link
      final richTextFinder = find.byWidgetPredicate((widget) => 
        widget is RichText && 
        widget.text.toPlainText().contains('personalisation service')
      );
      expect(richTextFinder, findsOneWidget);

      // 2. The Mechanics of testing TextSpans:
      // We cannot "tap" a Span because it's not a Widget. 
      // We have to find the specific gesture recognizer attached to that text.
      final richTextWidget = tester.widget<RichText>(richTextFinder);
      final textSpan = richTextWidget.text as TextSpan;
      
      // We traverse the children to find the one with the recognizer
      // Structure: Span("We offer...") -> Span("personalisation service") -> Span("!")
      final linkSpan = textSpan.children!.firstWhere(
        (span) => span is TextSpan && span.text == 'personalisation service'
      ) as TextSpan;

      // 3. Fire the tap event manually
      (linkSpan.recognizer as TapGestureRecognizer).onTap!();
      
      // 4. Wait for navigation animation
      await tester.pumpAndSettle();

      // 5. Verify we are now on the Print Shack Page
      // We check for a known unique text on that page (e.g., the price or title)
      // Based on your previous code:
      expect(find.byType(PrintShackPage), findsOneWidget);
    });
  });
}