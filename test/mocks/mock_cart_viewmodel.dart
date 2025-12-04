import 'package:flutter/material.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';

// This Mock allows us to test UI that depends on the Cart
// WITHOUT connecting to Firebase or LocalStorage.
class MockCartViewModel extends ChangeNotifier implements CartViewModel {
  List<Product> _items = [];

  @override
  List<Product> get rawItems => _items;

  @override
  List<Product> get uniqueProducts => _items.toSet().toList();

  @override
  double get totalPrice => _items.fold(0, (sum, item) => sum + item.price);

  @override
  void add(Product product) {
    _items.add(product);
    notifyListeners();
  }

  @override
  void clear() {
    _items.clear();
    notifyListeners();
  }

  @override
  int getQuantity(Product product) {
    return _items.where((p) => p.id == product.id).length;
  }

  @override
  void removeAllById(String productId) {
    _items.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  @override
  void updateQuantity(Product product, int newQuantity) {
    removeAllById(product.id);
    for (int i = 0; i < newQuantity; i++) {
      add(product);
    }
  }
  
  // We don't need these for simple tests, but the interface requires them
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}