import '../models/product.dart';

class CartRepository {
  // Internal Cache (The actual list holding cart items)
  final List<Product> _cartItems = [];

  List<Product> getCartItems() {
    return _cartItems;
  }

  void addItem(Product product) {
    _cartItems.add(product);
  }

  // FIX: Ensure this method signature matches the call in the ViewModel
  void removeAllById(String productId) {
    _cartItems.removeWhere((p) => p.id == productId);
  }
  
  void clear() {
    _cartItems.clear();
  }
  
  // FIX: Ensure this method signature matches the call in the ViewModel
  int getQuantity(Product product) {
    return _cartItems.where((p) => p.id == product.id).length;
  }
}