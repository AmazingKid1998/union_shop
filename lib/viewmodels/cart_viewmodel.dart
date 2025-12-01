import 'package:flutter/material.dart';
import '../models/product.dart';
import '../repositories/cart_repository.dart';

class CartViewModel extends ChangeNotifier {
  final CartRepository _cartRepository = CartRepository();

  // Expose unique items for display purposes
  List<Product> get uniqueProducts => _cartRepository.getCartItems().toSet().toList();
  
  // Expose the raw list (needed for total price calculation)
  List<Product> get rawItems => _cartRepository.getCartItems();

  double get totalPrice {
    return rawItems.fold(0, (total, current) => total + current.price);
  }
  
  // FIX 2: EXPOSE getQuantity method
  int getQuantity(Product product) {
    return _cartRepository.getQuantity(product);
  }

  // Actions
  void add(Product product) {
    _cartRepository.addItem(product);
    notifyListeners();
  }

  // FIX 1: EXPOSE updateQuantity method
  void updateQuantity(Product product, int newQuantity) {
    // 1. Remove all current copies of this product by ID
    _cartRepository.removeAllById(product.id);

    // 2. Add the new required quantity
    for (int i = 0; i < newQuantity; i++) {
        _cartRepository.addItem(product);
    }
    notifyListeners();
  }

  // FIX 3: EXPOSE removeAllById method
  void removeAllById(String productId) {
    _cartRepository.removeAllById(productId);
    notifyListeners();
  }
  
  void clear() {
    _cartRepository.clear();
    notifyListeners();
  }
}