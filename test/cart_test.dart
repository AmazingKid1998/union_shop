import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/models/product.dart';

void main() {
  group('CartViewModel Tests', () {
    late CartViewModel cartVM;
    late Product testProduct1;
    late Product testProduct2;
    
    setUp(() {
      cartVM = CartViewModel();
      
      testProduct1 = Product(
        id: 'p_test_1',
        title: 'Test Hoodie',
        price: 25.00,
        image: 'assets/test1.jpg',
        description: 'Test description',
        collectionIds: ['c_clothing'],
      );
      
      testProduct2 = Product(
        id: 'p_test_2',
        title: 'Test Tee',
        price: 15.00,
        image: 'assets/test2.jpg',
        description: 'Another test',
        collectionIds: ['c_clothing', 'c_essential'],
      );
    });

    // --- BASIC ADD OPERATIONS ---
    test('Add item updates total price', () {
      cartVM.add(testProduct1);
      
      expect(cartVM.totalPrice, 25.0);
      expect(cartVM.rawItems.length, 1);
    });

    test('Add multiple items calculates total correctly', () {
      cartVM.add(testProduct1);
      cartVM.add(testProduct2);
      cartVM.add(testProduct1);
      
      expect(cartVM.totalPrice, 65.0); // 25 + 15 + 25
      expect(cartVM.rawItems.length, 3);
    });

    // --- UNIQUE PRODUCTS ---
    test('uniqueProducts returns distinct items', () {
      cartVM.add(testProduct1);
      cartVM.add(testProduct1);
      cartVM.add(testProduct2);
      
      expect(cartVM.rawItems.length, 3);
      expect(cartVM.uniqueProducts.length, 2);
    });

    // --- QUANTITY OPERATIONS ---
    test('getQuantity returns correct count', () {
      cartVM.add(testProduct1);
      cartVM.add(testProduct1);
      cartVM.add(testProduct2);
      
      expect(cartVM.getQuantity(testProduct1), 2);
      expect(cartVM.getQuantity(testProduct2), 1);
    });

    test('updateQuantity correctly modifies item count', () {
      cartVM.add(testProduct1);
      expect(cartVM.getQuantity(testProduct1), 1);
      
      cartVM.updateQuantity(testProduct1, 5);
      
      expect(cartVM.getQuantity(testProduct1), 5);
      expect(cartVM.totalPrice, 125.0); // 25 * 5
    });

    test('updateQuantity to 1 works correctly', () {
      cartVM.add(testProduct1);
      cartVM.add(testProduct1);
      cartVM.add(testProduct1);
      expect(cartVM.getQuantity(testProduct1), 3);
      
      cartVM.updateQuantity(testProduct1, 1);
      
      expect(cartVM.getQuantity(testProduct1), 1);
      expect(cartVM.rawItems.length, 1);
    });

    // --- REMOVE OPERATIONS ---
    test('Remove all by ID removes all copies', () {
      cartVM.add(testProduct1);
      cartVM.add(testProduct1);
      cartVM.add(testProduct2);
      
      expect(cartVM.rawItems.length, 3);
      
      cartVM.removeAllById('p_test_1');
      
      expect(cartVM.rawItems.length, 1);
      expect(cartVM.getQuantity(testProduct1), 0);
      expect(cartVM.getQuantity(testProduct2), 1);
    });

    test('Remove non-existent ID does nothing', () {
      cartVM.add(testProduct1);
      
      cartVM.removeAllById('non_existent');
      
      expect(cartVM.rawItems.length, 1);
    });

    // --- CLEAR OPERATIONS ---
    test('Clear removes all items', () {
      cartVM.add(testProduct1);
      cartVM.add(testProduct2);
      
      cartVM.clear();
      
      expect(cartVM.rawItems.isEmpty, true);
      expect(cartVM.totalPrice, 0.0);
    });

    // --- EMPTY CART EDGE CASES ---
    test('Empty cart has zero total', () {
      expect(cartVM.totalPrice, 0.0);
      expect(cartVM.rawItems.isEmpty, true);
      expect(cartVM.uniqueProducts.isEmpty, true);
    });

    test('getQuantity returns 0 for non-existent product', () {
      final nonExistent = Product(
        id: 'non_existent',
        title: 'Not In Cart',
        price: 10.0,
        image: '',
        description: '',
        collectionIds: ['c_test'],
      );
      
      expect(cartVM.getQuantity(nonExistent), 0);
    });

    // --- PRODUCT WITH MULTIPLE COLLECTIONS ---
    test('Products with multiple collectionIds work correctly', () {
      final multiProduct = Product(
        id: 'p_multi',
        title: 'Multi Collection',
        price: 35.00,
        image: 'assets/multi.jpg',
        description: 'Multiple collections',
        collectionIds: ['c_clothing', 'c_grad', 'c_signature'],
      );
      
      cartVM.add(multiProduct);
      
      expect(cartVM.rawItems.first.collectionIds.length, 3);
      expect(cartVM.totalPrice, 35.0);
    });

    // --- CUSTOM PRODUCTS (Print Shack) ---
    test('Custom products with unique IDs are tracked separately', () {
      final custom1 = Product(
        id: 'custom_12345_0',
        title: 'Personalisation',
        price: 3.00,
        image: 'assets/print_preview.jpg',
        description: 'One Line of Text: Hello',
        collectionIds: ['custom'],
      );
      
      final custom2 = Product(
        id: 'custom_12346_0',
        title: 'Personalisation',
        price: 5.00,
        image: 'assets/print_preview.jpg',
        description: 'Two Lines of Text: Hello / World',
        collectionIds: ['custom'],
      );
      
      cartVM.add(custom1);
      cartVM.add(custom2);
      
      expect(cartVM.uniqueProducts.length, 2);
      expect(cartVM.totalPrice, 8.0);
    });

    // --- VARIANTS ---
    test('Products with variants have separate cart entries', () {
      final redHoodie = Product(
        id: 'p_hoodieRed',
        title: 'Hoodie',
        price: 30.00,
        image: 'assets/hoodie_red.jpg',
        description: 'Variant: Red',
        collectionIds: ['c_clothing'],
      );
      
      final blueHoodie = Product(
        id: 'p_hoodieBlue',
        title: 'Hoodie',
        price: 30.00,
        image: 'assets/hoodie_blue.jpg',
        description: 'Variant: Blue',
        collectionIds: ['c_clothing'],
      );
      
      cartVM.add(redHoodie);
      cartVM.add(blueHoodie);
      cartVM.add(redHoodie);
      
      expect(cartVM.uniqueProducts.length, 2);
      expect(cartVM.getQuantity(redHoodie), 2);
      expect(cartVM.getQuantity(blueHoodie), 1);
      expect(cartVM.totalPrice, 90.0);
    });

    // --- SALE ITEMS ---
    test('Products with oldPrice calculate total correctly', () {
      final saleItem = Product(
        id: 'p_sale',
        title: 'Sale Hoodie',
        price: 25.00,
        oldPrice: 35.00,
        image: 'assets/sale.jpg',
        description: 'On sale',
        collectionIds: ['c_clothing'],
      );
      
      cartVM.add(saleItem);
      cartVM.add(saleItem);
      
      // Total should use the current price, not oldPrice
      expect(cartVM.totalPrice, 50.0);
    });
  });
}