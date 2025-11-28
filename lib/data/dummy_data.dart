import '../models/product.dart';

// 1. Define our Collections (Categories)
final List<Collection> dummyCollections = [
  Collection(
    id: 'c1',
    title: 'Clothing',
    image: 'https://via.placeholder.com/300x200/4B0082/ffffff?text=Clothing',
  ),
  Collection(
    id: 'c2',
    title: 'Accessories',
    image: 'https://via.placeholder.com/300x200/2196f3/ffffff?text=Accessories',
  ),
];

// 2. Define our Products (Linked to Collection IDs)
final List<Product> dummyProducts = [
  Product(
    id: 'p1',
    title: 'Union Hoodie',
    price: 25.00,
    image: 'https://via.placeholder.com/300x300/4B0082/ffffff?text=Hoodie',
    description: 'A classic purple hoodie to show your Union pride. 100% Cotton.',
  ),
  Product(
    id: 'p2',
    title: 'UoP T-Shirt',
    price: 12.50,
    image: 'https://via.placeholder.com/300x300/e91e63/ffffff?text=T-Shirt',
    description: 'Breathable cotton t-shirt. Perfect for gym or lectures.',
  ),
  Product(
    id: 'p3',
    title: 'Coffee Mug',
    price: 8.00,
    image: 'https://via.placeholder.com/300x300/2196f3/ffffff?text=Mug',
    description: 'Start your morning right with this ceramic mug.',
  ),
];

// Helper to get products by collection (Simple filter)
List<Product> getProductsByCollection(String collectionId) {
  if (collectionId == 'c1') {
    return dummyProducts.where((p) => p.title.contains('Hoodie') || p.title.contains('Shirt')).toList();
  } else {
    return dummyProducts.where((p) => p.title.contains('Mug')).toList();
  }
}