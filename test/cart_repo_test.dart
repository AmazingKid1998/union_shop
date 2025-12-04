import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/repositories/cart_repository.dart';
import 'package:union_shop/models/product.dart';

void main() {
  late CartRepository repository;
  late Product testProduct1;
  late Product testProduct2;
  late Product testProduct3;

  setUp(() {
    repository = CartRepository();
    
    testProduct1 = Product(
      id: 'p_test_1',
      title: 'Test Hoodie',
      price: 25.00,
      image: 'assets/images/test1.webp',
      description: 'Test product 1',
      collectionIds: ['c_test', 'c_clothing'], // Updated to use list
    );
    
    testProduct2 = Product(
      id: 'p_test_2',
      title: 'Test T-Shirt',
      price: 12.00,
      image: 'assets/images/test2.webp',
      description: 'Test product 2',
      collectionIds: ['c_test'],
    );
    
    testProduct3 = Product(
      id: 'p_test_3',
      title: 'Test Pin',
      price: 15.00,
      image: 'assets/images/test3.webp',
      description: 'Test product 3',
      collectionIds: ['c_test', 'c_merch'],
    );
  });

  group('getCartItems', () {
    test('should return empty list when cart is empty', () {
      final items = repository.getCartItems();
      
      expect(items, isEmpty);
      expect(items, isA<List<Product>>());
    });

    test('should return list with items after adding products', () async {
      await repository.addItem(testProduct1);
      await repository.addItem(testProduct2);
      
      final items = repository.getCartItems();
      
      expect(items.length, 2);
      expect(items, contains(testProduct1));
      expect(items, contains(testProduct2));
    });
  });

  group('addItem', () {
    test('should add a single item to empty cart', () async {
      await repository.addItem(testProduct1);
      
      final items = repository.getCartItems();
      expect(items.length, 1);
      expect(items.first, testProduct1);
    });

    test('should add multiple different items', () async {
      await repository.addItem(testProduct1);
      await repository.addItem(testProduct2);
      await repository.addItem(testProduct3);
      
      final items = repository.getCartItems();
      expect(items.length, 3);
    });

    test('should allow adding same product multiple times', () async {
      await repository.addItem(testProduct1);
      await repository.addItem(testProduct1);
      await repository.addItem(testProduct1);
      
      final items = repository.getCartItems();
      expect(items.length, 3);
      expect(items.every((p) => p.id == testProduct1.id), isTrue);
    });

    test('should maintain order of added items', () async {
      await repository.addItem(testProduct1);
      await repository.addItem(testProduct2);
      await repository.addItem(testProduct3);
      
      final items = repository.getCartItems();
      expect(items[0], testProduct1);
      expect(items[1], testProduct2);
      expect(items[2], testProduct3);
    });
  });

  group('removeAllById', () {
    test('should remove all instances of a product by id', () async {
      await repository.addItem(testProduct1);
      await repository.addItem(testProduct1);
      await repository.addItem(testProduct2);
      await repository.addItem(testProduct1);
      
      await repository.removeAllById('p_test_1');
      
      final items = repository.getCartItems();
      expect(items.length, 1);
      expect(items.first.id, 'p_test_2');
    });

    test('should do nothing when removing non-existent product', () async {
      await repository.addItem(testProduct1);
      await repository.addItem(testProduct2);
      
      await repository.removeAllById('p_nonexistent');
      
      final items = repository.getCartItems();
      expect(items.length, 2);
    });

    test('should remove only matching product id', () async {
      await repository.addItem(testProduct1);
      await repository.addItem(testProduct2);
      await repository.addItem(testProduct3);
      await repository.addItem(testProduct2);
      
      await repository.removeAllById('p_test_2');
      
      final items = repository.getCartItems();
      expect(items.length, 2);
      expect(items.any((p) => p.id == 'p_test_2'), isFalse);
      expect(items.any((p) => p.id == 'p_test_1'), isTrue);
      expect(items.any((p) => p.id == 'p_test_3'), isTrue);
    });

    test('should handle empty cart gracefully', () async {
      await repository.removeAllById('p_test_1');
      
      final items = repository.getCartItems();
      expect(items, isEmpty);
    });
  });

  group('clear', () {
    test('should clear all items from cart', () async {
      await repository.addItem(testProduct1);
      await repository.addItem(testProduct2);
      await repository.addItem(testProduct3);
      
      await repository.clear();
      
      final items = repository.getCartItems();
      expect(items, isEmpty);
    });

    test('should handle clearing empty cart', () async {
      await repository.clear();
      
      final items = repository.getCartItems();
      expect(items, isEmpty);
    });

    test('should allow adding items after clearing', () async {
      await repository.addItem(testProduct1);
      await repository.clear();
      await repository.addItem(testProduct2);
      
      final items = repository.getCartItems();
      expect(items.length, 1);
      expect(items.first, testProduct2);
    });
  });

  group('getQuantity', () {
    test('should return 0 when product is not in cart', () {
      final quantity = repository.getQuantity(testProduct1);
      
      expect(quantity, 0);
    });

    test('should return 1 when product added once', () async {
      await repository.addItem(testProduct1);
      
      final quantity = repository.getQuantity(testProduct1);
      
      expect(quantity, 1);
    });

    test('should return correct count when same product added multiple times', () async {
      await repository.addItem(testProduct1);
      await repository.addItem(testProduct1);
      await repository.addItem(testProduct1);
      
      final quantity = repository.getQuantity(testProduct1);
      
      expect(quantity, 3);
    });

    test('should count only matching product id', () async {
      await repository.addItem(testProduct1);
      await repository.addItem(testProduct2);
      await repository.addItem(testProduct1);
      await repository.addItem(testProduct3);
      await repository.addItem(testProduct1);
      
      final quantity1 = repository.getQuantity(testProduct1);
      final quantity2 = repository.getQuantity(testProduct2);
      final quantity3 = repository.getQuantity(testProduct3);
      
      expect(quantity1, 3);
      expect(quantity2, 1);
      expect(quantity3, 1);
    });

    test('should return 0 after removing all instances', () async {
      await repository.addItem(testProduct1);
      await repository.addItem(testProduct1);
      
      await repository.removeAllById('p_test_1');
      
      final quantity = repository.getQuantity(testProduct1);
      expect(quantity, 0);
    });
  });

  group('Complex cart operations', () {
    test('should handle mixed operations correctly', () async {
      // Add items
      await repository.addItem(testProduct1);
      await repository.addItem(testProduct2);
      await repository.addItem(testProduct1);
      
      expect(repository.getQuantity(testProduct1), 2);
      expect(repository.getQuantity(testProduct2), 1);
      
      // Remove some
      await repository.removeAllById('p_test_1');
      
      expect(repository.getQuantity(testProduct1), 0);
      expect(repository.getQuantity(testProduct2), 1);
      
      // Add more
      await repository.addItem(testProduct3);
      await repository.addItem(testProduct3);
      
      expect(repository.getCartItems().length, 3);
      
      // Clear
      await repository.clear();
      
      expect(repository.getCartItems(), isEmpty);
      expect(repository.getQuantity(testProduct2), 0);
      expect(repository.getQuantity(testProduct3), 0);
    });

    test('should maintain cart state across multiple operations', () async {
      await repository.addItem(testProduct1);
      expect(repository.getCartItems().length, 1);
      
      await repository.addItem(testProduct2);
      expect(repository.getCartItems().length, 2);
      
      await repository.addItem(testProduct1);
      expect(repository.getCartItems().length, 3);
      expect(repository.getQuantity(testProduct1), 2);
      
      await repository.removeAllById('p_test_1');
      expect(repository.getCartItems().length, 1);
      expect(repository.getQuantity(testProduct1), 0);
      expect(repository.getQuantity(testProduct2), 1);
    });
  });

  group('Edge cases', () {
    test('should handle rapid add and remove operations', () async {
      for (int i = 0; i < 10; i++) {
        await repository.addItem(testProduct1);
      }
      expect(repository.getQuantity(testProduct1), 10);
      
      await repository.removeAllById('p_test_1');
      expect(repository.getQuantity(testProduct1), 0);
    });

    test('should handle products with same properties but different instances', () async {
      final product1Instance1 = Product(
        id: 'p_same',
        title: 'Same Product',
        price: 10.00,
        image: 'assets/images/same.webp',
        description: 'Same',
        collectionIds: ['c_test'],
      );
      
      final product1Instance2 = Product(
        id: 'p_same',
        title: 'Same Product',
        price: 10.00,
        image: 'assets/images/same.webp',
        description: 'Same',
        collectionIds: ['c_test'],
      );
      
      await repository.addItem(product1Instance1);
      await repository.addItem(product1Instance2);
      
      expect(repository.getQuantity(product1Instance1), 2);
      expect(repository.getQuantity(product1Instance2), 2);
      
      await repository.removeAllById('p_same');
      expect(repository.getCartItems(), isEmpty);
    });

    test('cart should remain empty after multiple clear operations', () async {
      await repository.addItem(testProduct1);
      await repository.clear();
      await repository.clear();
      await repository.clear();
      
      expect(repository.getCartItems(), isEmpty);
    });
  });

  group('Products with multiple collectionIds', () {
    test('should correctly handle products belonging to multiple collections', () async {
      final multiCollectionProduct = Product(
        id: 'p_multi',
        title: 'Multi Collection Product',
        price: 30.00,
        image: 'assets/images/multi.webp',
        description: 'In multiple collections',
        collectionIds: ['c_clothing', 'c_grad', 'c_signature'],
      );

      await repository.addItem(multiCollectionProduct);
      
      final items = repository.getCartItems();
      expect(items.length, 1);
      expect(items.first.collectionIds.length, 3);
      expect(items.first.collectionIds.contains('c_clothing'), isTrue);
      expect(items.first.collectionIds.contains('c_grad'), isTrue);
      expect(items.first.collectionIds.contains('c_signature'), isTrue);
    });
  });
}