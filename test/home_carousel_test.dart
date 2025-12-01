import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/widgets/home_carousel.dart'; // Adjust path if needed

void main() {
  
  // 1. HELPER: Create the test environment
  // We need MaterialApp because the widget uses Navigator (Navigator.pushNamed)
  // We define "Dummy Routes" so the test knows where to go.
  Widget createCarouselTestWidget() {
    return MaterialApp(
      routes: {
        '/': (context) => const Scaffold(body: HomeCarousel()), // The Widget Under Test
        '/print-shack': (context) => const Scaffold(body: Text('Print Shack Screen')), // Dummy Destination
      },
    );
  }

  group('HomeCarousel Logic Tests', () {

    // --- TEST 1: INITIAL RENDER ---
    testWidgets('Displays the first slide correctly on load', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(createCarouselTestWidget());

      // Verify Slide 1 Content is present
      expect(find.text('The Print Shack'), findsOneWidget);
      expect(find.text('FIND OUT MORE'), findsOneWidget);

      // Verify Slide 2 Content is NOT present yet (Off-screen)
      expect(find.text('Essential Range -\nOver 20% OFF!'), findsNothing);
    });

    // --- TEST 2: NAVIGATION ---
    testWidgets('Clicking CTA button navigates to correct route', (WidgetTester tester) async {
      await tester.pumpWidget(createCarouselTestWidget());

      // 1. Find the button on Slide 1
      final ctaButton = find.widgetWithText(ElevatedButton, 'FIND OUT MORE');
      
      // 2. Tap it
      await tester.ensureVisible(ctaButton);
      await tester.tap(ctaButton);
      
      // 3. Wait for navigation animation
      await tester.pumpAndSettle();

      // 4. Verify we are on the new page
      // We look for the text "Print Shack Screen" which matches our dummy route above
      expect(find.text('Print Shack Screen'), findsOneWidget);
    });

    // --- TEST 3: CAROUSEL MOVEMENT (ARROWS) ---
    testWidgets('Clicking Right Arrow switches to Slide 2', (WidgetTester tester) async {
      await tester.pumpWidget(createCarouselTestWidget());

      // 1. Verify we start on Slide 1
      expect(find.text('The Print Shack'), findsOneWidget);

      // 2. Find Right Arrow
      final rightArrow = find.byIcon(Icons.chevron_right);
      
      // 3. Tap it
      await tester.tap(rightArrow);
      
      // 4. Wait for animation
      await tester.pumpAndSettle();

      // 5. Verify Slide 1 is gone
      expect(find.text('The Print Shack'), findsNothing); 

      // 6. Verify Slide 2 is visible
      // FIX: Use unique text to avoid "Found 2 widgets" error
      expect(find.text('BROWSE COLLECTION'), findsOneWidget);
      // Optional: Check specific description text
      expect(find.textContaining('Come and grab yours'), findsOneWidget);
    });
  });
}
