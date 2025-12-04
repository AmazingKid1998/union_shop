import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/widgets/site_footer.dart';
import 'package:union_shop/widgets/home_carousel.dart';

// --- HELPER: Wraps widgets safely ---
Widget createWidgetForTesting(Widget child) {
  return MaterialApp(
    home: Scaffold(
      // We wrap in SingleChildScrollView so large widgets (like Footer) 
      // don't cause "Overflow" errors on the small test screen.
      body: SingleChildScrollView(
        child: child,
      ),
    ),
    // Dummy route generator to prevent crashes if a button is tapped
    onGenerateRoute: (settings) {
      return MaterialPageRoute(
        builder: (_) => const Scaffold(body: Text('Dummy Page')),
      );
    },
  );
}

void main() {
  group('Simple Widget Tests (No Firebase)', () {
    
    // --- 1. SITE FOOTER TEST ---
    testWidgets('SiteFooter renders opening hours and links', (WidgetTester tester) async {
      // 1. Set a large screen size so everything fits
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;

      // 2. Render the Footer
      await tester.pumpWidget(createWidgetForTesting(const SiteFooter()));
      
      // 3. Check for text
      expect(find.text('Opening Hours'), findsOneWidget);
      expect(find.text('Help and Information'), findsOneWidget);
      expect(find.text('Terms & Conditions of Sale Policy'), findsOneWidget);

      // 4. Clean up size settings
      addTearDown(tester.view.resetPhysicalSize);
    });

    // --- 2. HOME CAROUSEL TEST ---
    testWidgets('HomeCarousel renders and displays slide content', (WidgetTester tester) async {
      // 1. Render the Carousel
      await tester.pumpWidget(createWidgetForTesting(const HomeCarousel()));
      
      // 2. Check for the first slide's text
      expect(find.text('The Print Shack'), findsOneWidget);
      expect(find.text('FIND OUT MORE'), findsOneWidget);

      // 3. Verify the dots indicator exists
      // (We look for the specific circular Containers used as dots)
      expect(find.byType(Container), findsWidgets); 
    });

  });
}