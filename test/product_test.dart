import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/product.dart';

void main() {
  group('Product Model Tests', () {
    
    // --- TEST 1: FULL DATA WITH MULTIPLE COLLECTION IDS ---
    test('Can be instantiated with all fields including multiple collectionIds', () {
      final product = Product(
        id: 'p_101',
        title: 'Premium Hoodie',
        price: 45.00,
        oldPrice: 50.00,
        image: 'assets/hoodie_default.jpg',
        description: 'A warm hoodie',
        collectionIds: ['c_clothing', 'c_signature'], // Multiple collections
        variants: {
          'Red': 'assets/hoodie_red.jpg',
          'Blue': 'assets/hoodie_blue.jpg',
        },
      );

      expect(product.id, 'p_101');
      expect(product.title, 'Premium Hoodie');
      expect(product.price, 45.00);
      expect(product.oldPrice, 50.00);
      expect(product.collectionIds, ['c_clothing', 'c_signature']);
      expect(product.collectionIds.length, 2);
      expect(product.variants?['Red'], 'assets/hoodie_red.jpg');
    });

    // --- TEST 2: MINIMAL DATA (Nullable Checks) ---
    test('Can be instantiated with only required fields', () {
      final product = Product(
        id: 'p_102',
        title: 'Basic Tee',
        price: 15.00,
        image: 'assets/tee.jpg',
        description: 'Simple tee',
        collectionIds: ['c_clothing'],
      );

      expect(product.id, 'p_102');
      expect(product.oldPrice, null);
      expect(product.variants, null);
      expect(product.collectionIds.length, 1);
    });

    // --- TEST 3: JSON SERIALIZATION ---
    test('toJson correctly serializes product', () {
      final product = Product(
        id: 'p_103',
        title: 'Test Product',
        price: 20.00,
        oldPrice: 25.00,
        image: 'assets/test.jpg',
        description: 'Test description',
        collectionIds: ['c_test', 'c_merch'],
        variants: {'Default': 'assets/default.jpg'},
      );

      final json = product.toJson();

      expect(json['id'], 'p_103');
      expect(json['title'], 'Test Product');
      expect(json['price'], 20.00);
      expect(json['oldPrice'], 25.00);
      expect(json['collectionIds'], ['c_test', 'c_merch']);
      expect(json['variants'], {'Default': 'assets/default.jpg'});
    });

    // --- TEST 4: JSON DESERIALIZATION WITH NEW FORMAT ---
    test('fromJson correctly deserializes product with collectionIds list', () {
      final json = {
        'id': 'p_104',
        'title': 'Deserialized Product',
        'price': 30.0,
        'oldPrice': 35.0,
        'image': 'assets/deser.jpg',
        'description': 'Deserialized desc',
        'collectionIds': ['c_clothing', 'c_grad'],
        'variants': null,
      };

      final product = Product.fromJson(json);

      expect(product.id, 'p_104');
      expect(product.title, 'Deserialized Product');
      expect(product.price, 30.00);
      expect(product.oldPrice, 35.00);
      expect(product.collectionIds, ['c_clothing', 'c_grad']);
      expect(product.variants, null);
    });

    // --- TEST 5: JSON MIGRATION (Old collectionId to new collectionIds) ---
    test('fromJson handles migration from old collectionId format', () {
      final oldJson = {
        'id': 'p_105',
        'title': 'Legacy Product',
        'price': 10.0,
        'image': 'assets/legacy.jpg',
        'description': 'Legacy desc',
        'collectionId': 'c_old_format', // Old format
      };

      final product = Product.fromJson(oldJson);

      expect(product.collectionIds, ['c_old_format']);
      expect(product.collectionIds.length, 1);
    });

    // --- TEST 6: JSON WITH NULL COLLECTION IDS ---
    test('fromJson handles null collectionIds gracefully', () {
      final json = {
        'id': 'p_106',
        'title': 'No Collection Product',
        'price': 5.0,
        'image': 'assets/nocol.jpg',
        'description': 'No collection',
        'collectionIds': null,
        'collectionId': null,
      };

      final product = Product.fromJson(json);

      expect(product.collectionIds, isEmpty);
    });

    // --- TEST 7: ROUND TRIP (toJson -> fromJson) ---
    test('Product survives round trip serialization', () {
      final original = Product(
        id: 'p_roundtrip',
        title: 'Round Trip Test',
        price: 99.99,
        oldPrice: 120.00,
        image: 'assets/round.jpg',
        description: 'Testing round trip',
        collectionIds: ['c_clothing', 'c_signature', 'c_essential'],
        variants: {
          'Small': 'assets/small.jpg',
          'Large': 'assets/large.jpg',
        },
      );

      final json = original.toJson();
      final restored = Product.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.price, original.price);
      expect(restored.oldPrice, original.oldPrice);
      expect(restored.collectionIds, original.collectionIds);
      expect(restored.variants, original.variants);
    });

    // --- TEST 8: PRICE AS INT FROM JSON ---
    test('fromJson handles price as integer', () {
      final json = {
        'id': 'p_int',
        'title': 'Int Price',
        'price': 10, // Integer, not double
        'image': 'assets/int.jpg',
        'description': 'desc',
        'collectionIds': ['c_test'],
      };

      final product = Product.fromJson(json);

      expect(product.price, 10.0);
      expect(product.price, isA<double>());
    });
  });
}