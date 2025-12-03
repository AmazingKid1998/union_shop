import 'dart:convert'; // For JSON encoding/decoding
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class CartRepository {
  List<Product> _cartItems = [];
  static const String _storageKey = 'union_shop_cart';

  List<Product> getCartItems() {
    return _cartItems;
  }

  // --- PERSISTENCE METHODS ---

  // Load cart from disk (Async)
  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartJson = prefs.getString(_storageKey);

    if (cartJson != null) {
      // Decode JSON string -> List of Maps -> List of Products
      final List<dynamic> decodedList = json.decode(cartJson);
      _cartItems = decodedList.map((item) => Product.fromJson(item)).toList();
    }
  }

  // Save cart to disk
  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    // Convert List of Products -> List of Maps -> JSON String
    final String encodedList = json.encode(_cartItems.map((p) => p.toJson()).toList());
    await prefs.setString(_storageKey, encodedList);
  }

  // --- MODIFICATION METHODS (Now auto-save) ---

  void addItem(Product product) {
    _cartItems.add(product);
    _saveCart();
  }

  void removeAllById(String productId) {
    _cartItems.removeWhere((p) => p.id == productId);
    _saveCart();
  }
  
  void clear() {
    _cartItems.clear();
    _saveCart();
  }
  
  int getQuantity(Product product) {
    return _cartItems.where((p) => p.id == product.id).length;
  }
}