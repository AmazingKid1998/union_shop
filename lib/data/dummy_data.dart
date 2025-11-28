import '../models/product.dart';

// No "Collection" list needed anymore!

final List<Product> dummyProducts = [
  // --- CLOTHING (c_clothing) ---
  Product(
    id: 'p1',
    title: 'Classic Hoodies',
    price: 25.00,
    image: 'https://via.placeholder.com/300x300/4B0082/ffffff?text=Classic+Hoodie',
    description: 'Our best selling Classic Hoodie comes in great colours!',
    collectionId: 'c_clothing',
  ),
  Product(
    id: 'p2',
    title: 'Classic Sweatshirts',
    price: 23.00,
    image: 'https://via.placeholder.com/300x300/3f51b5/ffffff?text=Sweatshirt',
    description: 'A comfortable classic sweatshirt.',
    collectionId: 'c_clothing',
  ),

  // --- MERCHANDISE (c_merch) ---
  Product(
    id: 'p12',
    title: 'Portsmouth City Postcard',
    price: 1.00,
    image: 'https://via.placeholder.com/300x300/00bcd4/ffffff?text=Postcard',
    description: 'A beautiful postcard.',
    collectionId: 'c_merch',
  ),

  // --- HALLOWEEN (c_halloween) ---
  Product(
    id: 'h1',
    title: 'Limited Edition Spooky Tee',
    price: 15.00,
    image: 'https://via.placeholder.com/300x300/ff9800/000000?text=Pumpkin+Tee',
    description: 'Scary good comfort.',
    collectionId: 'c_halloween',
  ),

  // --- SIGNATURE & ESSENTIAL (c_signature) ---
  Product(
    id: 's1',
    title: 'Signature Hoodie',
    price: 32.99,
    image: 'https://via.placeholder.com/300x300/1a237e/ffffff?text=Signature',
    description: 'Premium quality hoodie.',
    collectionId: 'c_signature',
  ),

  // --- PORTSMOUTH CITY (c_city) ---
  Product(
    id: 'pc1',
    title: 'Portsmouth City Magnet',
    price: 4.50,
    image: 'https://via.placeholder.com/300x300/607d8b/ffffff?text=Magnet',
    description: 'Fridge magnet.',
    collectionId: 'c_city',
  ),

  // --- PRIDE (c_pride) ---
  Product(
    id: 'pr1',
    title: 'Pride Flag Pin',
    price: 3.00,
    image: 'https://via.placeholder.com/300x300/FFC107/ffffff?text=Pride+Pin',
    description: 'Wear your pride.',
    collectionId: 'c_pride',
  ),

  // --- GRADUATION (c_grad) ---
  Product(
    id: 'g1',
    title: 'Graduation Bear',
    price: 12.00,
    image: 'https://via.placeholder.com/300x300/795548/ffffff?text=Grad+Bear',
    description: 'A cute bear for your big day.',
    collectionId: 'c_grad',
  ),
];

// Simple filter logic
List<Product> getProductsByCollection(String collectionId) {
  return dummyProducts.where((p) => p.collectionId == collectionId).toList();
}