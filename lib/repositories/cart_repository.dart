import '../models/product.dart';

class CartRepository {
  // Internal Cache
  final List<Product> _cartItems = [];

  // Get Items
  List<Product> getCartItems() {
    return _cartItems;
  }

  // Add Item
  void addItem(Product product) {
    _cartItems.add(product);
  }

  // Remove Item (All copies or single copy logic can go here)
  void removeProduct(Product product) {
    _cartItems.remove(product);
  }
  
  void removeAt(int index) {
    _cartItems.removeAt(index);
  }

  void clear() {
    _cartItems.clear();
  }
}