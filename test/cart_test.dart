import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/models/product.dart';

// Mock the CartRepository to provide simple synchronous operations without Firebase/storage issues
class MockCartRepository extends CartRepository {
  List<Product> _mockCartItems = [];
  
  @override
  List<Product> getCartItems() => _mockCartItems;
  
  @override
  Future<void> loadCart() async {} // Stub loading
  
  @override
  Future<void> addItem(Product product) async {
    _mockCartItems.add(product);
  }

  @override
  Future<void> removeAllById(String productId) async {
    _mockCartItems.removeWhere((p) => p.id == productId);
  }
  
  @override
  Future<void> clear() async {
    _mockCartItems.clear();
  }
}

// Mock the CartViewModel to use the synchronous mock repository
class MockCartViewModel extends CartViewModel {
  MockCartViewModel() : super.test(MockCartRepository());

  // Private constructor bypasses the real super() constructor
  MockCartViewModel.test(CartRepository repo) : super.test(repo);
}

void main() {
  group('CartViewModel - Price and Quantity Logic (Simplified)', () {
    late MockCartViewModel cartVM;
    late Product testProduct1;
    
    setUp(() {
      cartVM = MockCartViewModel(); 
      testProduct1 = Product(
        id: 'p_test_1',
        title: 'Test Hoodie',
        price: 25.00,
        image: 'assets/test1.jpg',
        description: 'Test description',
        collectionIds: ['c_clothing'],
      );
    });

    test('Add item updates total price correctly', () {
      cartVM.add(testProduct1);
      
      expect(cartVM.totalPrice, 25.0);
    });

    test('Total price reflects multiple items', () {
      cartVM.add(testProduct1);
      cartVM.add(testProduct1);
      
      expect(cartVM.totalPrice, 50.0);
    });

    test('updateQuantity correctly modifies item count and total', () {
      cartVM.add(testProduct1); // Qty 1
      cartVM.updateQuantity(testProduct1, 5); // Qty 5
      
      expect(cartVM.getQuantity(testProduct1), 5);
      expect(cartVM.totalPrice, 125.0); // 25 * 5
    });

    test('Clear removes all items and resets total', () {
      cartVM.add(testProduct1);
      cartVM.clear();
      
      expect(cartVM.rawItems.isEmpty, isTrue);
      expect(cartVM.totalPrice, 0.0);
    });
  });
}