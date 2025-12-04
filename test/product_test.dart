import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/product.dart';

void main() {
  group('Product Model Tests (Simplified)', () {
    
    test('Can be instantiated with all required fields and collections list', () {
      final product = Product(
        id: 'p_101',
        title: 'Premium Hoodie',
        price: 45.00,
        oldPrice: 50.00,
        image: 'assets/hoodie_default.jpg',
        description: 'A warm hoodie',
        collectionIds: ['c_clothing', 'c_signature'],
      );

      expect(product.title, 'Premium Hoodie');
      expect(product.collectionIds, contains('c_clothing'));
      expect(product.oldPrice, 50.00);
    });

    test('toJson and fromJson handle price correctly', () {
      final json = {
        'id': 'p_104',
        'title': 'Deserialized Product',
        'price': 30, // Test with integer price from JSON
        'image': 'assets/deser.jpg',
        'description': 'Deserialized desc',
        'collectionIds': ['c_clothing'],
        'variants': null,
      };

      final product = Product.fromJson(json);

      expect(product.price, 30.0);
      expect(product.price, isA<double>());
      expect(product.toJson()['price'], 30.0);
    });
  });
}