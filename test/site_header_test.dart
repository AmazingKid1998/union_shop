import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/widgets/site_header.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart'; // Required by provider tree
import 'package:union_shop/models/product.dart';

// Helper: Create a minimal test harness for the header
Widget createHeaderTest({CartViewModel? cartVM}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => cartVM ?? CartViewModel()),
      ChangeNotifierProvider(create: (_) => ShopViewModel()), // Mock or use real
    ],
    child: const MaterialApp(
      home: Scaffold(appBar: SiteHeader()),
    ),
  );
}

void main() {
  group('SiteHeader - Cart Badge Logic Tests', () {
    testWidgets('Cart Badge appears and correctly displays item count', (WidgetTester tester) async {
      final cart = CartViewModel();
      
      await tester.pumpWidget(createHeaderTest(cartVM: cart));
      await tester.pumpAndSettle();
      
      // Start Empty -> Badge should NOT be visible
      expect(find.text('1'), findsNothing);

      // Add Item
      cart.add(Product(
        id: 'test_1', 
        title: 'Tee', 
        price: 10, 
        image: 'img.jpg', 
        description: 'desc', 
        collectionIds: ['c_clothing'],
      ));
      
      await tester.pumpAndSettle(); // Rebuild UI

      // Verify Red Badge appears with '1'
      expect(find.text('1'), findsOneWidget);

      // Add two more items
      cart.add(cart.rawItems.first); // Same item ID for simplicity
      cart.add(cart.rawItems.first);
      
      await tester.pumpAndSettle(); // Rebuild UI
      
      // Verify count is 3
      expect(find.text('3'), findsOneWidget);
    });
  });
}