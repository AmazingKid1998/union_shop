import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/repositories/product_repository.dart';

void main() {
  late ProductRepository repository;

  setUp(() {
    repository = ProductRepository();
  });

  group('ProductRepository Tests', () {
    test('getAllProducts returns list of products', () async {
      final products = await repository.getAllProducts();
      expect(products, isNotEmpty);
      expect(products.first.title, isNotNull);
    });

    test('getProductById returns correct product', () {
      final product = repository.getProductById('p_classic_hoodie');
      expect(product.id, 'p_classic_hoodie');
      expect(product.title, 'Classic Hoodie');
    });

    test('getProductsByCollection filters correctly', () {
      final clothing = repository.getProductsByCollection('c_clothing');
      
      // Check that every returned item actually has 'c_clothing' in its list
      for (var p in clothing) {
        expect(p.collectionIds, contains('c_clothing'));
      }
    });

    test('getSaleProducts returns only items with oldPrice', () {
      // FIXED: Changed getSaleItems() to getSaleProducts()
      final saleItems = repository.getSaleProducts(); 
      for (var p in saleItems) {
        expect(p.oldPrice, isNotNull);
      }
    });
  });
}