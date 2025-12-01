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
      oldPrice: 35.00,
      image: 'assets/images/p1.jpeg',
      description: 'Our best selling Classic Hoodie comes in great colours!',
      collectionId: 'c_clothing',
    ),
    // ... add the rest ...
  ];

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