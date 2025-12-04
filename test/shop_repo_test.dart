import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/repositories/product_repository.dart';

void main() {
  late ProductRepository repository;

  setUp(() {
    repository = ProductRepository();
  });

  group('ProductRepository - Core Data Integrity Tests', () {
    test('getAllProducts should return a non-empty list of products', () async {
      // Test 1: Basic retrieval check
      final products = await repository.getAllProducts();
      expect(products, isNotEmpty);
    });

    test('All products must have a List of collectionIds (new format)', () async {
      // Test 2: Crucial structural check (ensures no migration errors)
      final products = await repository.getAllProducts();
      for (final product in products) {
        expect(product.collectionIds, isA<List<String>>());
        expect(product.collectionIds, isNotEmpty, reason: 'Product ${product.id} must belong to at least one collection.');
      }
    });

    test('getProductById retrieves a known product', () {
      // Test 3: Simple lookup check
      final product = repository.getProductById('p_classic_hoodie');
      expect(product.id, 'p_classic_hoodie');
      expect(product.title, 'Classic Hoodie');
    });
  });
}