import 'package:flutter/material.dart';
import '../models/product.dart';
import '../repositories/cart_repository.dart';

class CartViewModel extends ChangeNotifier {
  final CartRepository _cartRepository = CartRepository();

  // Constructor triggers the data load
  CartViewModel() {
    _loadData();
  }

  // Async function to load persisted data
  Future<void> _loadData() async {
    await _cartRepository.loadCart();
    notifyListeners(); // Refresh UI once data is loaded from disk
  }

  // Expose unique items for display purposes
  List<Product> get uniqueProducts => _cartRepository.getCartItems().toSet().toList();
  
  // Expose the raw list
  List<Product> get rawItems => _cartRepository.getCartItems();

  double get totalPrice {
    return rawItems.fold(0, (total, current) => total + current.price);
  }
  
  int getQuantity(Product product) {
    return _cartRepository.getQuantity(product);
  }

  // Actions
  void add(Product product) {
    _cartRepository.addItem(product);
    notifyListeners();
  }

  void updateQuantity(Product product, int newQuantity) {
    _cartRepository.removeAllById(product.id);
    for (int i = 0; i < newQuantity; i++) {
        _cartRepository.addItem(product);
    }
    notifyListeners();
  }

  void removeAllById(String productId) {
    _cartRepository.removeAllById(productId);
    notifyListeners();
  }
  
  void clear() {
    _cartRepository.clear();
    notifyListeners();
  }
}