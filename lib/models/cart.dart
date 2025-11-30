import 'product.dart';

// Global cart list accessed by all pages
List<Product> globalCart = [];

// Helper to calculate total price
double getCartTotal() {
  return globalCart.fold(0, (total, current) => total + current.price);
}