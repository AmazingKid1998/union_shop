import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/repositories/cart_repository.dart';
import 'package:union_shop/models/product.dart';

// NOTE: We only test the synchronous list manipulation, ignoring the Firebase/SharedPreferences logic.
void main() {
  late CartRepository repository;
  late Product testProduct1;

  setUp(() {
    // Re-initialize the repository for each test to ensure an empty cart
    repository = CartRepository(); 
    
    testProduct1 = Product(
      id: 'p_test_1',
      title: 'Test Hoodie',
      price: 25.00,
      image: 'assets/images/test1.webp',
      description: 'Test product 1',
      collectionIds: ['c_test'],
    );
  });

  group('CartRepository - Core List Manipulation (Simplified)', () {
    test('addItem and getQuantity work correctly for multiple copies', () async {
      await repository.addItem(testProduct1);
      await repository.addItem(testProduct1);
      
      final items = repository.getCartItems();
      
      expect(items.length, 2);
      expect(repository.getQuantity(testProduct1), 2);
    });

    test('removeAllById removes all copies of a product', () async {
      await repository.addItem(testProduct1);
      await repository.addItem(testProduct1);
      
      await repository.removeAllById('p_test_1');
      
      expect(repository.getCartItems(), isEmpty);
      expect(repository.getQuantity(testProduct1), 0);
    });

    test('clear resets the cart to empty', () async {
      await repository.addItem(testProduct1);
      expect(repository.getCartItems(), isNotEmpty);
      
      await repository.clear();
      
      expect(repository.getCartItems(), isEmpty);
    });
  });
}