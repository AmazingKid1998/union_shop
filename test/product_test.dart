import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/product.dart';

void main() {
  group('Product Model Tests', () {
    
    // --- TEST 1: FULL DATA ---
    test('Can be instantiated with all fields including variants', () {
      final product = Product(
        id: 'p_101',
        title: 'Premium Hoodie',
        price: 45.00,
        oldPrice: 50.00,
        image: 'assets/hoodie_default.jpg',
        description: 'A warm hoodie',
        collectionId: 'c_clothing',
        variants: {
          'Red': 'assets/hoodie_red.jpg',
          'Blue': 'assets/hoodie_blue.jpg',
        },
      );

      expect(product.id, 'p_101');
      expect(product.title, 'Premium Hoodie');
      expect(product.price, 45.00);
      expect(product.oldPrice, 50.00);
      expect(product.variants?['Red'], 'assets/hoodie_red.jpg');
    });

    // --- TEST 2: MINIMAL DATA (Nullable Checks) ---
    test('Can be instantiated with only required fields', () {
      final product = Product(
        id: 'p_102',
        title: 'Basic Tee',
        price: 15.00,
        // oldPrice is omitted (should be null)
        image: 'assets/tee.jpg',
        description: 'Simple tee',
        collectionId: 'c_clothing',
        // variants is omitted (should be null)
      );

      expect(product.id, 'p_102');
      expect(product.oldPrice, null);
      expect(product.variants, null);
    });
  });
}