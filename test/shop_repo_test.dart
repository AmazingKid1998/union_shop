import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/repositories/product_repository.dart';
import 'package:union_shop/models/product.dart';

void main() {
  late ProductRepository repository;

  setUp(() {
    repository = ProductRepository();
  });

  group('getAllProducts', () {
    test('should return all products', () async {
      final products = await repository.getAllProducts();
      
      expect(products, isNotEmpty);
      expect(products.length, 11);
    });

    test('should return products with correct properties', () async {
      final products = await repository.getAllProducts();
      
      for (final product in products) {
        expect(product.id, isNotEmpty);
        expect(product.title, isNotEmpty);
        expect(product.price, greaterThan(0));
        expect(product.image, isNotEmpty);
        expect(product.collectionIds, isNotEmpty);
      }
    });

    test('all products should have collectionIds as List', () async {
      final products = await repository.getAllProducts();
      
      for (final product in products) {
        expect(product.collectionIds, isA<List<String>>());
      }
    });
  });

  group('getProductById', () {
    test('should return correct product when valid id is provided', () {
      final product = repository.getProductById('p_classic_hoodie');
      
      expect(product.id, 'p_classic_hoodie');
      expect(product.title, 'Classic Hoodie');
      expect(product.price, 25.00);
      expect(product.oldPrice, 35.00);
    });

    test('should return product for graduation pin', () {
      final product = repository.getProductById('p_grad_1');
      
      expect(product.id, 'p_grad_1');
      expect(product.title, 'Graduation Pin');
      expect(product.price, 15.00);
      expect(product.collectionIds, contains('c_grad'));
    });

    test('should return product with variants', () {
      final product = repository.getProductById('p_essential_tee');
      
      expect(product.variants, isNotNull);
      expect(product.variants?.length, 2);
      expect(product.variants?['Blue'], 'assets/images/essential_blue.webp');
      expect(product.variants?['Green'], 'assets/images/essential_green.webp');
    });

    test('should return first product when invalid id is provided', () {
      final product = repository.getProductById('invalid_id');
      
      expect(product, isNotNull);
      expect(product.id, 'p_classic_hoodie'); // First product in list
    });
  });

  group('getProductsByCollection - Multi-collection support', () {
    test('should return all clothing products', () {
      final products = repository.getProductsByCollection('c_clothing');
      
      // Classic Hoodie, Essential T-Shirt, Signature T-Shirt, Graduation Hoodie 2025
      expect(products.length, greaterThanOrEqualTo(3));
      expect(products.every((p) => p.collectionIds.contains('c_clothing')), isTrue);
    });

    test('should return all graduation products', () {
      final products = repository.getProductsByCollection('c_grad');
      
      expect(products.length, 2);
      expect(products.every((p) => p.collectionIds.contains('c_grad')), isTrue);
      
      final titles = products.map((p) => p.title).toList();
      expect(titles, containsAll(['Graduation Pin', 'Graduation Hoodie 2025']));
    });

    test('should return all merchandise products', () {
      final products = repository.getProductsByCollection('c_merch');
      
      expect(products.length, greaterThanOrEqualTo(4));
      expect(products.every((p) => p.collectionIds.contains('c_merch')), isTrue);
    });

    test('should return halloween products', () {
      final products = repository.getProductsByCollection('c_halloween');
      
      expect(products.length, 1);
      expect(products.first.title, 'Spooky Tote Bag');
      expect(products.first.variants?.length, 2);
    });

    test('should return empty list for non-existent collection', () {
      final products = repository.getProductsByCollection('c_nonexistent');
      
      expect(products, isEmpty);
    });

    test('products in multiple collections appear in each query', () {
      // Essential T-Shirt is in c_clothing AND c_essential
      final clothing = repository.getProductsByCollection('c_clothing');
      final essential = repository.getProductsByCollection('c_essential');
      
      final essentialTee = repository.getProductById('p_essential_tee');
      
      expect(clothing.any((p) => p.id == essentialTee.id), isTrue);
      expect(essential.any((p) => p.id == essentialTee.id), isTrue);
    });

    test('Signature T-Shirt is in both clothing and signature', () {
      final clothing = repository.getProductsByCollection('c_clothing');
      final signature = repository.getProductsByCollection('c_signature');
      
      expect(clothing.any((p) => p.id == 'p_signature'), isTrue);
      expect(signature.any((p) => p.id == 'p_signature'), isTrue);
    });

    test('Graduation Hoodie is in both grad and clothing', () {
      final grad = repository.getProductsByCollection('c_grad');
      final clothing = repository.getProductsByCollection('c_clothing');
      
      expect(grad.any((p) => p.id == 'p_grad_2'), isTrue);
      expect(clothing.any((p) => p.id == 'p_grad_2'), isTrue);
    });

    test('City products are in both city and merch', () {
      final city = repository.getProductsByCollection('c_city');
      final merch = repository.getProductsByCollection('c_merch');
      
      expect(city.length, 2); // Postcard and Magnet
      
      for (final product in city) {
        expect(merch.any((p) => p.id == product.id), isTrue);
      }
    });
  });

  group('getSaleProducts', () {
    test('should return only products with oldPrice', () {
      final saleProducts = repository.getSaleProducts();
      
      expect(saleProducts, isNotEmpty);
      expect(saleProducts.every((p) => p.oldPrice != null), isTrue);
    });

    test('should return correct number of sale products', () {
      final saleProducts = repository.getSaleProducts();
      
      expect(saleProducts.length, 3); // Classic Hoodie, Lanyard, Uni Pen
    });

    test('should include Classic Hoodie in sale products', () {
      final saleProducts = repository.getSaleProducts();
      
      final hoodie = saleProducts.firstWhere((p) => p.id == 'p_classic_hoodie');
      expect(hoodie.price, 25.00);
      expect(hoodie.oldPrice, 35.00);
    });

    test('should include merchandise sale items', () {
      final saleProducts = repository.getSaleProducts();
      
      final saleIds = saleProducts.map((p) => p.id).toList();
      expect(saleIds, containsAll(['p_merch_1', 'p_merch_2']));
    });

    test('sale products should have price less than oldPrice', () {
      final saleProducts = repository.getSaleProducts();
      
      for (final product in saleProducts) {
        expect(product.price, lessThan(product.oldPrice!));
      }
    });
  });

  group('Product variants', () {
    test('Classic Hoodie should have 3 color variants', () {
      final product = repository.getProductById('p_classic_hoodie');
      
      expect(product.variants?.length, 3);
      expect(product.variants?.keys, containsAll(['Grey', 'Navy', 'Purple']));
    });

    test('Essential T-Shirt should have 2 color variants', () {
      final product = repository.getProductById('p_essential_tee');
      
      expect(product.variants?.length, 2);
      expect(product.variants?.keys, containsAll(['Blue', 'Green']));
    });

    test('Signature T-Shirt should have 2 color variants', () {
      final product = repository.getProductById('p_signature');
      
      expect(product.variants?.length, 2);
      expect(product.variants?.keys, containsAll(['Blue', 'Sand']));
    });

    test('Halloween product should have 2 style variants', () {
      final product = repository.getProductById('p_halloween');
      
      expect(product.variants?.length, 2);
      expect(product.variants?.keys, containsAll(['Ghost Style', 'Boo Style']));
    });

    test('products without variants should have null variants', () {
      final product = repository.getProductById('p_grad_1');
      
      expect(product.variants, isNull);
    });
  });

  group('Price validation', () {
    test('all products should have positive prices', () async {
      final products = await repository.getAllProducts();
      
      for (final product in products) {
        expect(product.price, greaterThan(0));
      }
    });

    test('products on sale should have correct price reduction', () {
      final hoodie = repository.getProductById('p_classic_hoodie');
      expect(hoodie.oldPrice! - hoodie.price, 10.00);
      
      final lanyard = repository.getProductById('p_merch_1');
      expect(lanyard.oldPrice! - lanyard.price, 3.00);
      
      final pen = repository.getProductById('p_merch_2');
      expect(pen.oldPrice! - pen.price, 2.00);
    });
  });

  group('Collection integrity with multi-collection products', () {
    test('all products should belong to at least one valid collection', () async {
      final products = await repository.getAllProducts();
      final validCollections = [
        'c_clothing', 'c_grad', 'c_merch', 'c_halloween',
        'c_city', 'c_signature', 'c_essential', 'c_pride'
      ];
      
      for (final product in products) {
        expect(product.collectionIds.isNotEmpty, isTrue);
        expect(
          product.collectionIds.any((id) => validCollections.contains(id)),
          isTrue,
          reason: '${product.title} has no valid collection ID'
        );
      }
    });

    test('products with multiple collections have all valid IDs', () async {
      final products = await repository.getAllProducts();
      final multiCollectionProducts = products.where(
        (p) => p.collectionIds.length > 1
      );
      
      expect(multiCollectionProducts.isNotEmpty, isTrue);
      
      for (final product in multiCollectionProducts) {
        for (final collectionId in product.collectionIds) {
          expect(collectionId.startsWith('c_'), isTrue);
        }
      }
    });
  });

  group('Specific product data integrity', () {
    test('Essential T-Shirt has correct multi-collection setup', () {
      final product = repository.getProductById('p_essential_tee');
      
      expect(product.collectionIds, contains('c_clothing'));
      expect(product.collectionIds, contains('c_essential'));
      expect(product.collectionIds.length, 2);
    });

    test('Signature T-Shirt has correct multi-collection setup', () {
      final product = repository.getProductById('p_signature');
      
      expect(product.collectionIds, contains('c_clothing'));
      expect(product.collectionIds, contains('c_signature'));
    });

    test('City Postcard has correct multi-collection setup', () {
      final product = repository.getProductById('p_city_postcard');
      
      expect(product.collectionIds, contains('c_city'));
      expect(product.collectionIds, contains('c_merch'));
    });
  });
}