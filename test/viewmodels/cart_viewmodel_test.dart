import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/models/product.dart';

// Import the helper we just created
import '../firebase_mock.dart'; 

void main() {
  // 1. Run the robust mock setup
  setupFirebaseMocks();

  late CartViewModel cartVM;

  setUpAll(() async {
    // 2. Initialize Firebase (This will now hit our Pigeon mock)
    await Firebase.initializeApp();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    cartVM = CartViewModel();
  });

  group('CartViewModel Tests', () {
    final testProduct = Product(
      id: 'test_p', 
      title: 'Test', 
      price: 10.0, 
      image: 'img', 
      description: 'desc', 
      collectionIds: []
    );

    test('Starts empty', () {
      expect(cartVM.uniqueProducts, isEmpty);
      expect(cartVM.totalPrice, 0.0);
    });

    test('Add item increases count and price', () {
      cartVM.add(testProduct);
      expect(cartVM.uniqueProducts.length, 1);
      expect(cartVM.getQuantity(testProduct), 1);
      expect(cartVM.totalPrice, 10.0);
    });

    test('Update quantity modifies cart', () {
      cartVM.add(testProduct);
      cartVM.updateQuantity(testProduct, 3);
      expect(cartVM.getQuantity(testProduct), 3);
      expect(cartVM.totalPrice, 30.0);
    });

    test('Clear empties the cart', () {
      cartVM.add(testProduct);
      cartVM.clear();
      expect(cartVM.uniqueProducts, isEmpty);
    });
  });
}