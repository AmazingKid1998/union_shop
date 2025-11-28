import 'product.dart';

// Just a simple global list
List<Product> globalCart = [];

// A simple helper to get the total
double getCartTotal() {
  return globalCart.fold(0, (total, current) => total + current.price);
}