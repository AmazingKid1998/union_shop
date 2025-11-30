import '../models/product.dart';

final List<Product> dummyProducts = [
  // --- CLOTHING ---
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

// Helper to get ONLY sale items
List<Product> getSaleProducts() {
  return dummyProducts.where((p) => p.oldPrice != null).toList();
}

// Keep your existing getProductsByCollection function
List<Product> getProductsByCollection(String collectionId) {
  if (collectionId == 'c_clothing') {
     return dummyProducts.where((p) => 
       p.collectionId == 'c_clothing' || p.title.contains('Graduation Hoodie')
     ).toList();
  }
  if (collectionId == 'c_merch') {
     return dummyProducts.where((p) => 
       p.collectionId == 'c_merch' || p.collectionId == 'c_city'
     ).toList();
  }
  return dummyProducts.where((p) => p.collectionId == collectionId).toList();
}