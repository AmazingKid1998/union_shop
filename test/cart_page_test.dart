import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/pages/cart_page.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart'; // Required by SiteHeader

Widget createCartTest({CartViewModel? cartVM}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => cartVM ?? CartViewModel()),
      ChangeNotifierProvider(create: (_) => ShopViewModel()), // Mock or use real
    ],
    child: const MaterialApp(
      home: CartPage(),
    ),
  );
}

void main() {
  group('CartPage - Empty State Tests', () {
    testWidgets('Shows empty message and hides checkout section when cart is empty', (WidgetTester tester) async {
      // Use a freshly instantiated (empty) CartViewModel
      await tester.pumpWidget(createCartTest(cartVM: CartViewModel())); 
      await tester.pumpAndSettle();
      
      // 1. Verify Empty Message is Visible
      expect(find.text('Your basket is empty.'), findsOneWidget);
      
      // 2. Verify Checkout/Subtotal elements are hidden
      expect(find.text('Subtotal'), findsNothing);
      expect(find.text('Check out'), findsNothing);
      
      // 3. Verify core navigation link is present
      expect(find.text('Continue shopping'), findsOneWidget);
    });
  });
}