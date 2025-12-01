import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/models/product.dart';

void main() {
  group('CartViewModel Tests', () {
    late CartViewModel cartVM;
    
    setUp(() {
      cartVM = CartViewModel();
    });

    test('Add item updates total price', () {
      final p1 = Product(
        id: '1', title: 'Test', price: 10.0, image: '', description: '', collectionId: 'c1'
      );
      
      cartVM.add(p1);
      
      expect(cartVM.totalPrice, 10.0);
      expect(cartVM.rawItems.length, 1);
    });

    test('Remove all by ID removes all copies', () {
      final p1 = Product(
        id: '1', title: 'Test', price: 10.0, image: '', description: '', collectionId: 'c1'
      );
      
      cartVM.add(p1);
      cartVM.add(p1); // Add twice
      
      expect(cartVM.rawItems.length, 2);
      
      cartVM.removeAllById('1');
      
      expect(cartVM.rawItems.length, 0);
    });
  });
}