import '../models/product.dart';

class ProductRepository {
  // 1. Internal Cache
  final List<Product> _products = [
    // PASTE YOUR FULL LIST OF DUMMY PRODUCTS HERE (from dummy_data.dart)
    // I am abbreviating for brevity, but you should copy the whole list.
    Product(
    id: 'p1',
    title: 'Classic Hoodies',
    price: 25.00, 
    oldPrice: 35.00, // <--- ON SALE!
    image: 'assets/images/p1.jpeg',
    description: 'Our best selling Classic Hoodie comes in great colours!',
    collectionId: 'c_clothing',
  ),
  Product(
    id: 'p2',
    title: 'Classic Sweatshirts',
    price: 23.00,
    // No oldPrice -> Not on sale
    image: 'assets/images/p2.jpeg',
    description: 'A comfortable classic sweatshirt perfect for everyday wear.',
    collectionId: 'c_clothing',
  ),
  Product(
    id: 'p3',
    title: 'Classic T-Shirts',
    price: 11.00,
    oldPrice: 15.00, // <--- ON SALE!
    image: 'assets/images/p1.jpeg',
    description: 'Soft cotton T-shirt featuring the Union logo.',
    collectionId: 'c_clothing',
  ),
  // ... (Keep the rest of your products the same, just copy them back in)
  // For brevity, I am showing the first 3. You should keep your full list of 18 items.
  // Just ensure you add the 'oldPrice: null,' or leave it out for non-sale items.
  
  // Example of another sale item
  Product(
    id: 'p6',
    title: 'Limited Edition Zip Hoodie',
    price: 20.00,
    oldPrice: 30.00, // <--- ON SALE!
    image: 'assets/images/p1.jpeg',
    description: 'Limited run essential zip hoodie.',
    collectionId: 'c_clothing',
  ),
  
  // ... (Paste the rest of your products here) ...
];
    // ... add the rest ...

  // 2. Methods to access data (As requested by professor)
  
  // Get all products
  Future<List<Product>> getAllProducts() async {
    // Simulate network delay if you want, or just return
    return _products;
  }

  // Get by ID
  Product getProductById(String id) {
    return _products.firstWhere((p) => p.id == id);
  }

  // Get by Collection
  List<Product> getProductsByCollection(String collectionId) {
    if (collectionId == 'c_clothing') {
       return _products.where((p) => 
         p.collectionId == 'c_clothing' || p.title.contains('Graduation Hoodie')
       ).toList();
    }
    if (collectionId == 'c_merch') {
       return _products.where((p) => 
         p.collectionId == 'c_merch' || p.collectionId == 'c_city'
       ).toList();
    }
    return _products.where((p) => p.collectionId == collectionId).toList();
  }
  
  // Get Sale Products
  List<Product> getSaleProducts() {
    return _products.where((p) => p.oldPrice != null).toList();
  }
}