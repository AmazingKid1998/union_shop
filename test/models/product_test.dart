import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/product.dart';

void main() {
  group('Product Model Tests', () {
    test('Product should be created correctly', () {
      final product = Product(
        id: 'test_1',
        title: 'Test Product',
        price: 10.0,
        image: 'assets/test.jpg',
        description: 'Description',
        collectionIds: ['c_test'],
      );

      expect(product.id, 'test_1');
      expect(product.price, 10.0);
      expect(product.collectionIds, contains('c_test'));
    });

    test('fromJson should parse JSON correctly', () {
      final json = {
        'id': 'p_1',
        'title': 'JSON Product',
        'price': 20.0,
        'image': 'img.png',
        'description': 'Desc',
        'collectionIds': ['c_1', 'c_2'],
        'variants': {'Blue': 'img_blue.png'}
      };

      final product = Product.fromJson(json);

      expect(product.id, 'p_1');
      expect(product.variants, isNotNull);
      expect(product.variants!['Blue'], 'img_blue.png');
    });

    test('toJson should convert Product to Map correctly', () {
      final product = Product(
        id: 'test_2',
        title: 'To JSON',
        price: 15.0,
        image: 'img.png',
        description: 'Desc',
        collectionIds: ['c_clothing'],
      );

      final json = product.toJson();

      expect(json['id'], 'test_2');
      expect(json['price'], 15.0);
      expect(json['collectionIds'], isA<List>());
    });
  });
}