import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/pages/about_page.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';
import 'package:union_shop/test/cart_test.dart'; // Import MockCartViewModel

// Helper function to create the test harness with mocked CartViewModel
Widget createTestWidget() {
  return MultiProvider(
    providers: [
      // Use the mock to prevent Firebase/Async crashes
      ChangeNotifierProvider<CartViewModel>(create: (_) => MockCartViewModel()),
      ChangeNotifierProvider(create: (_) => ShopViewModel()),
    ],
    child: const MaterialApp(
      home: AboutPage(),
    ),
  );
}

void main() {
  group('AboutPage Tests (Simplified)', () {
    
    testWidgets('Renders main title and essential text blocks', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 1. Verify Title
      expect(find.text('About us'), findsOneWidget);

      // 2. Verify key introductory and signature text
      expect(find.text('Welcome to the Union Shop!'), findsOneWidget);
      expect(find.text('The Union Shop & Reception Team'), findsOneWidget);
    });

    testWidgets('Contains the clickable "personalisation service" link', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the text that contains the link
      final linkFinder = find.byWidgetPredicate((widget) => 
        widget is RichText && 
        widget.text.toPlainText().contains('personalisation service')
      );
      expect(linkFinder, findsOneWidget);
    });
  });
}