import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
import '../repositories/cart_repository.dart';

class CartViewModel extends ChangeNotifier {
  final CartRepository _cartRepository = CartRepository();
  StreamSubscription? _authSubscription;

  CartViewModel() {
    _loadData();
    
    // Listen for Login/Logout events
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      // When auth state changes (login or logout), reload the cart
      _loadData();
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    await _cartRepository.loadCart();
    notifyListeners();
  }

  List<Product> get uniqueProducts => _cartRepository.getCartItems().toSet().toList();
  List<Product> get rawItems => _cartRepository.getCartItems();

  double get totalPrice {
    return rawItems.fold(0, (total, current) => total + current.price);
  }
  
  int getQuantity(Product product) {
    return _cartRepository.getQuantity(product);
  }

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