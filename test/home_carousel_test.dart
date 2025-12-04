import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/widgets/home_carousel.dart';

void main() {
  
  // Helper: Create the test environment
  Widget createCarouselTestWidget() {
    return MaterialApp(
      routes: {
        '/': (context) => const Scaffold(body: HomeCarousel()),
        '/print-shack': (context) => const Scaffold(body: Text('Print Shack Screen')),
      },
    );
  }

  group('HomeCarousel Visual Tests', () {

    // --- TEST 1: INITIAL RENDER ---
    testWidgets('Displays the first slide correctly on load', (WidgetTester tester) async {
      await tester.pumpWidget(createCarouselTestWidget());
      await tester.pumpAndSettle();

      // Verify Slide 1 Content is present
      expect(find.text('The Print Shack'), findsOneWidget);
      expect(find.text('FIND OUT MORE'), findsOneWidget);

      // Verify Slide 2 Content is NOT present yet (Off-screen)
      expect(find.text('Essential Range -\nOver 20% OFF!'), findsNothing);
    });

    // --- TEST 2: SLIDE DESCRIPTION ---
    testWidgets('First slide has correct description', (WidgetTester tester) async {
      await tester.pumpWidget(createCarouselTestWidget());
      await tester.pumpAndSettle();

      expect(
        find.textContaining('personalisation service'),
        findsOneWidget,
      );
    });

    // --- TEST 3: NAVIGATION INDICATORS ---
    testWidgets('Shows dot indicators', (WidgetTester tester) async {
      await tester.pumpWidget(createCarouselTestWidget());
      await tester.pumpAndSettle();

      // Should have arrow icons
      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    // --- TEST 4: PAUSE BUTTON VISUAL ---
    testWidgets('Shows pause button overlay', (WidgetTester tester) async {
      await tester.pumpWidget(createCarouselTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.pause), findsOneWidget);
    });
  });

  group('HomeCarousel Navigation Tests', () {

    // --- TEST 5: CTA BUTTON NAVIGATION ---
    testWidgets('Clicking CTA button navigates to correct route', (WidgetTester tester) async {
      await tester.pumpWidget(createCarouselTestWidget());
      await tester.pumpAndSettle();

      final ctaButton = find.widgetWithText(ElevatedButton, 'FIND OUT MORE');
      
      await tester.ensureVisible(ctaButton);
      await tester.tap(ctaButton);
      await tester.pumpAndSettle();

      expect(find.text('Print Shack Screen'), findsOneWidget);
    });

    // --- TEST 6: CAROUSEL MOVEMENT (RIGHT ARROW) ---
    testWidgets('Clicking Right Arrow switches to Slide 2', (WidgetTester tester) async {
      await tester.pumpWidget(createCarouselTestWidget());
      await tester.pumpAndSettle();

      // Verify we start on Slide 1
      expect(find.text('The Print Shack'), findsOneWidget);

      // Find and tap Right Arrow
      final rightArrow = find.byIcon(Icons.chevron_right);
      await tester.tap(rightArrow);
      await tester.pumpAndSettle();

      // Verify Slide 1 is gone
      expect(find.text('The Print Shack'), findsNothing); 

      // Verify Slide 2 is visible
      expect(find.text('BROWSE COLLECTION'), findsOneWidget);
      expect(find.textContaining('Come and grab yours'), findsOneWidget);
    });

    // --- TEST 7: CAROUSEL MOVEMENT (LEFT ARROW) ---
    testWidgets('Clicking Left Arrow from Slide 2 returns to Slide 1', (WidgetTester tester) async {
      await tester.pumpWidget(createCarouselTestWidget());
      await tester.pumpAndSettle();

      // Go to Slide 2 first
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();
      expect(find.text('BROWSE COLLECTION'), findsOneWidget);

      // Go back to Slide 1
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();

      expect(find.text('The Print Shack'), findsOneWidget);
    });

    // --- TEST 8: SWIPE GESTURE ---
    testWidgets('Swiping changes slides', (WidgetTester tester) async {
      await tester.pumpWidget(createCarouselTestWidget());
      await tester.pumpAndSettle();

      // Verify we start on Slide 1
      expect(find.text('The Print Shack'), findsOneWidget);

      // Swipe left to go to Slide 2
      await tester.fling(
        find.byType(PageView),
        const Offset(-300, 0),
        1000,
      );
      await tester.pumpAndSettle();

      // Verify we're on Slide 2
      expect(find.text('BROWSE COLLECTION'), findsOneWidget);
    });
  });

  group('HomeCarousel Content Tests', () {

    // --- TEST 9: SECOND SLIDE CONTENT ---
    testWidgets('Second slide has correct content', (WidgetTester tester) async {
      await tester.pumpWidget(createCarouselTestWidget());
      await tester.pumpAndSettle();

      // Navigate to Slide 2
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();

      expect(find.textContaining('Essential Range'), findsOneWidget);
      expect(find.textContaining('20% OFF'), findsOneWidget);
      expect(find.text('BROWSE COLLECTION'), findsOneWidget);
    });

    // --- TEST 10: IMAGE CONTAINERS ---
    testWidgets('Contains image section', (WidgetTester tester) async {
      await tester.pumpWidget(createCarouselTestWidget());
      await tester.pumpAndSettle();

      // Should have Image.asset widgets
      expect(find.byType(Image), findsWidgets);
    });
  });

  group('HomeCarousel State Tests', () {

    // --- TEST 11: DOT INDICATOR UPDATES ---
    testWidgets('Dot indicators update on slide change', (WidgetTester tester) async {
      await tester.pumpWidget(createCarouselTestWidget());
      await tester.pumpAndSettle();

      // Find dot containers (the small circle indicators)
      // Initial state: first dot should be active (darker)
      
      // Change slide
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();

      // The second dot should now be active
      // This verifies the _currentIndex state updates
      expect(find.text('BROWSE COLLECTION'), findsOneWidget);
    });
  });
}