import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart'; // Ensure this matches your project name in pubspec.yaml
import 'package:union_shop/models/cart.dart';
import 'package:union_shop/models/product.dart';

void main() {
  // 1. Test the Homepage UI
  testWidgets('Homepage loads and displays Essential Range', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const UnionShopApp());

    // Verify that the Navbar title is present
    expect(find.text('The UNION'), findsOneWidget);

    // Verify that the "Essential Range" section title is present
    expect(find.text('Essential Range'), findsOneWidget);

    // Verify that "Shop" and "About" buttons exist
    expect(find.text('Shop'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
  });

  // 2. Test the Cart Logic (Unit Test)
  test('Cart Logic adds and calculates total correctly', () {
    // Clear cart first
    globalCart.clear();

    // Create a dummy product
    final p1 = Product(
      id: 't1', 
      title: 'Test Item', 
      price: 10.0, 
      image: '', 
      description: ''
    );

    // Add to cart
    globalCart.add(p1);
    globalCart.add(p1); // Add twice

    // Check count
    expect(globalCart.length, 2);

    // Check total price
    expect(getCartTotal(), 20.0);
  });
}