import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/widgets/site_footer.dart';

void main() {
  
  Widget createFooterTest() {
    return const MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: SiteFooter(),
        ),
      ),
    );
  }

  group('SiteFooter Visual Tests', () {
    testWidgets('Renders all informational text correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createFooterTest());

      // Headers
      expect(find.text('Opening Hours'), findsOneWidget);
      expect(find.text('Help and Information'), findsOneWidget);
      expect(find.text('Latest Offers'), findsOneWidget);
      
      // Content
      expect(find.textContaining('Winter Break Closure Dates'), findsOneWidget);
      expect(find.textContaining('Closing 4pm 19/12/2025'), findsOneWidget);
      
      // Links
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Terms & Conditions of Sale Policy'), findsOneWidget);
    });
  });

  group('SiteFooter Interaction Tests', () {
    
    // Removed the flaky "Search" test as requested.
    
    testWidgets('Subscribe Form accepts input', (WidgetTester tester) async {
      await tester.pumpWidget(createFooterTest());

      // 1. Find the Email Field
      final emailField = find.widgetWithText(TextField, 'Email address');
      await tester.ensureVisible(emailField);
      
      // 2. Enter Text
      await tester.enterText(emailField, 'student@port.ac.uk');
      await tester.pump();

      // 3. Verify Text matches
      expect(find.text('student@port.ac.uk'), findsOneWidget);

      // 4. Tap Subscribe (Smoke check)
      final subscribeBtn = find.text('SUBSCRIBE');
      await tester.ensureVisible(subscribeBtn);
      await tester.tap(subscribeBtn);
    });
  });
}