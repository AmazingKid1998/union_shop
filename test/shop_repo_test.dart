import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/repositories/product_repository.dart';

void main() {
  late ProductRepository repository;

  setUp(() {
    repository = ProductRepository();
  });

  group('ProductRepository - Core Data Integrity Tests (Simplified)', () {
    test('getAllProducts should return a non-empty list of products', () async {
      final products = await repository.getAllProducts();
      expect(products, isNotEmpty);
      expect(products.every((p) => p.collectionIds.isNotEmpty), isTrue);
    });

    test('getProductById retrieves the Classic Hoodie', () {
      final product = repository.getProductById('p_classic_hoodie');
      expect(product.id, 'p_classic_hoodie');
      expect(product.oldPrice, 35.00);
    });

    test('getProductsByCollection returns items in the requested collection (c_grad)', () {
      final products = repository.getProductsByCollection('c_grad');
      expect(products, isNotEmpty);
      expect(products.every((p) => p.collectionIds.contains('c_grad')), isTrue);
    });
  });
}