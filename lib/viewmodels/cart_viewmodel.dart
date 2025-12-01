import 'package:flutter/material.dart';
import '../models/product.dart';
import '../repositories/cart_repository.dart';

class CartViewModel extends ChangeNotifier {
  final CartRepository _cartRepository = CartRepository();

  // Expose items
  List<Product> get items => _cartRepository.getCartItems();

  // Expose Total Price
  double get totalPrice {
    return items.fold(0, (total, current) => total + current.price);
  }
  
  // Expose Count
  int get count => items.length;

  // Actions
  void add(Product product) {
    _cartRepository.addItem(product);
    notifyListeners(); // Tells UI to rebuild
  }

  void removeAt(int index) {
    _cartRepository.removeAt(index);
    notifyListeners();
  }
  
  void removeProduct(Product product) {
    _cartRepository.removeProduct(product);
    notifyListeners();
  }
  
  void clear() {
    _cartRepository.clear();
    notifyListeners();
  }
}