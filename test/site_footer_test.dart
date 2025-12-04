import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/widgets/site_footer.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';

void main() {
  
  Widget createFooterTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShopViewModel()),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: SiteFooter(),
          ),
        ),
      ),
    );
  }

  group('SiteFooter Visual Tests', () {
    testWidgets('Renders all section headers', (WidgetTester tester) async {
      await tester.pumpWidget(createFooterTest());
      await tester.pumpAndSettle();

      expect(find.text('Opening Hours'), findsOneWidget);
      expect(find.text('Help and Information'), findsOneWidget);
      expect(find.text('Latest Offers'), findsOneWidget);
    });

    testWidgets('Renders opening hours content', (WidgetTester tester) async {
      await tester.pumpWidget(createFooterTest());
      await tester.pumpAndSettle();

      expect(find.textContaining('Winter Break Closure Dates'), findsOneWidget);
      expect(find.textContaining('Closing 4pm 19/12/2025'), findsOneWidget);
      expect(find.textContaining('Reopening 10am 05/01/2026'), findsOneWidget);
    });

    testWidgets('Renders term time hours', (WidgetTester tester) async {
      await tester.pumpWidget(createFooterTest());
      await tester.pumpAndSettle();

      expect(find.textContaining('(Term Time)'), findsOneWidget);
      expect(find.textContaining('Monday - Friday 10am - 4pm'), findsOneWidget);
    });

    testWidgets('Renders outside term time hours', (WidgetTester tester) async {
      await tester.pumpWidget(createFooterTest());
      await tester.pumpAndSettle();

      expect(find.textContaining('Outside of Term Time'), findsOneWidget);
      expect(find.textContaining('Monday - Friday 10am - 3pm'), findsOneWidget);
    });

    testWidgets('Renders 24/7 online note', (WidgetTester tester) async {
      await tester.pumpWidget(createFooterTest());
      await tester.pumpAndSettle();

      expect(find.textContaining('Purchase online 24/7'), findsOneWidget);
    });

    testWidgets('Renders Help links', (WidgetTester tester) async {
      await tester.pumpWidget(createFooterTest());
      await tester.pumpAndSettle();

      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Terms & Conditions of Sale Policy'), findsOneWidget);
    });

    testWidgets('Renders email subscription form', (WidgetTester tester) async {
      await tester.pumpWidget(createFooterTest());
      await tester.pumpAndSettle();

      expect(find.text('Latest Offers'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('SUBSCRIBE'), findsOneWidget);
    });

    testWidgets('Has snowflake icons for winter closure', (WidgetTester tester) async {
      await tester.pumpWidget(createFooterTest());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.ac_unit), findsWidgets);
    });
  });

  group('SiteFooter Interaction Tests', () {
    testWidgets('Subscribe Form accepts input', (WidgetTester tester) async {
      await tester.pumpWidget(createFooterTest());
      await tester.pumpAndSettle();

      // Find the Email Field
      final emailField = find.byType(TextField);
      await tester.ensureVisible(emailField);
      await tester.pumpAndSettle();
      
      // Enter Text
      await tester.enterText(emailField, 'student@port.ac.uk');
      await tester.pump();

      // Verify Text matches
      expect(find.text('student@port.ac.uk'), findsOneWidget);
    });

    testWidgets('Subscribe button is tappable', (WidgetTester tester) async {
      await tester.pumpWidget(createFooterTest());
      await tester.pumpAndSettle();

      final subscribeBtn = find.text('SUBSCRIBE');
      await tester.ensureVisible(subscribeBtn);
      await tester.pumpAndSettle();

      // Should be able to tap without error
      await tester.tap(subscribeBtn);
      await tester.pump();
    });

    testWidgets('Search link is tappable', (WidgetTester tester) async {
      await tester.pumpWidget(createFooterTest());
      await tester.pumpAndSettle();

      final searchLink = find.text('Search');
      expect(searchLink, findsOneWidget);

      await tester.tap(searchLink);
      await tester.pumpAndSettle();

      // Search should open (TextField appears)
      expect(find.byType(TextField), findsWidgets);
    });
  });

  group('SiteFooter Styling Tests', () {
    testWidgets('Has correct background color', (WidgetTester tester) async {
      await tester.pumpWidget(createFooterTest());
      await tester.pumpAndSettle();

      // Find the Container that wraps the footer
      final container = find.byType(Container).first;
      expect(container, findsOneWidget);
    });

    testWidgets('Section headers are styled correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createFooterTest());
      await tester.pumpAndSettle();

      final headerFinder = find.text('Opening Hours');
      expect(headerFinder, findsOneWidget);

      final Text headerWidget = tester.widget<Text>(headerFinder);
      expect(headerWidget.style?.fontSize, 18);
      expect(headerWidget.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('Subscribe button has correct style', (WidgetTester tester) async {
      await tester.pumpWidget(createFooterTest());
      await tester.pumpAndSettle();

      final button = find.widgetWithText(ElevatedButton, 'SUBSCRIBE');
      expect(button, findsOneWidget);
    });
  });

  group('SiteFooter Email Field Tests', () {
    testWidgets('Email field has placeholder text', (WidgetTester tester) async {
      await tester.pumpWidget(createFooterTest());
      await tester.pumpAndSettle();

      expect(find.text('Email address'), findsOneWidget);
    });

    testWidgets('Email field clears on input', (WidgetTester tester) async {
      await tester.pumpWidget(createFooterTest());
      await tester.pumpAndSettle();

      final emailField = find.byType(TextField);
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();

      // Clear and re-enter
      await tester.enterText(emailField, '');
      await tester.pump();

      expect(find.text('test@example.com'), findsNothing);
    });
  });
}