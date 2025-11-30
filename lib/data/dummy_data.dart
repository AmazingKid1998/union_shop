import '../models/product.dart';

// The 18 Products + Extras, using Local Assets and Collection IDs
final List<Product> dummyProducts = [
  // --- CLOTHING (c_clothing) ---
  Product(
    id: 'p1',
    title: 'Classic Hoodies',
    price: 25.00,
    image: 'assets/images/p1.jpg', 
    description: 'Our best selling Classic Hoodie comes in great colours! Double Fabric Hood with self colour flat hood cords.',
    collectionId: 'c_clothing',
  ),
  Product(
    id: 'p2',
    title: 'Classic Sweatshirts',
    price: 23.00,
    image: 'assets/images/p2.jpg',
    description: 'A comfortable classic sweatshirt perfect for everyday wear.',
    collectionId: 'c_clothing',
  ),
  Product(
    id: 'p3',
    title: 'Classic T-Shirts',
    price: 11.00,
    image: 'assets/images/p3.jpg',
    description: 'Soft cotton T-shirt featuring the Union logo. A wardrobe essential.',
    collectionId: 'c_clothing',
  ),
  Product(
    id: 'p4',
    title: 'Graduation Hoodies',
    price: 35.00,
    image: 'assets/images/p4.jpg',
    description: 'Celebrate your achievement with our official Graduation Hoodie.',
    collectionId: 'c_grad', // Also tagged as graduation
  ),
  Product(
    id: 'p5',
    title: 'Classic Sweatshirts - Neutral',
    price: 17.00,
    image: 'assets/images/p5.jpg',
    description: 'The classic sweatshirt in a range of stylish neutral tones.',
    collectionId: 'c_clothing',
  ),
  Product(
    id: 'p6',
    title: 'Limited Edition Essential Zip Hoodies',
    price: 20.00,
    image: 'assets/images/p6.jpg',
    description: 'Limited run essential zip hoodie. Grab yours while stock lasts.',
    collectionId: 'c_clothing',
  ),
  Product(
    id: 'p7',
    title: 'Essential T-Shirt',
    price: 10.00,
    image: 'assets/images/p7.jpg',
    description: 'Great value essential T-shirt for your daily rotation.',
    collectionId: 'c_clothing',
  ),
  Product(
    id: 'p8',
    title: 'Christmas Jumper',
    price: 16.00,
    image: 'assets/images/p8.jpg',
    description: 'Get festive with the official Union Christmas jumper!',
    collectionId: 'c_clothing',
  ),
  Product(
    id: 'p9',
    title: 'Heavyweight Shorts',
    price: 20.00,
    image: 'assets/images/p9.jpg',
    description: 'Durable heavyweight shorts, perfect for sports or lounging.',
    collectionId: 'c_clothing',
  ),
  
  // --- SIGNATURE RANGE (c_signature) ---
  Product(
    id: 'p10',
    title: 'Signature Hoodie',
    price: 32.99,
    image: 'assets/images/p10.jpg',
    description: 'Premium quality hoodie from our exclusive Signature range.',
    collectionId: 'c_signature',
  ),
  Product(
    id: 'p11',
    title: 'Signature T-Shirt',
    price: 14.99,
    image: 'assets/images/p11.jpg',
    description: 'Premium cotton T-shirt from our exclusive Signature range.',
    collectionId: 'c_signature',
  ),

  // --- MERCHANDISE (c_merch) & CITY COLLECTION (c_city) ---
  Product(
    id: 'p12',
    title: 'Portsmouth City Postcard',
    price: 1.00,
    image: 'assets/images/p12.jpg',
    description: 'A beautiful postcard featuring iconic Portsmouth City landmarks.',
    collectionId: 'c_merch',
  ),
  Product(
    id: 'p13',
    title: 'Portsmouth City Magnet',
    price: 4.50,
    image: 'assets/images/p13.jpg',
    description: 'Fridge magnet to remember your time in Portsmouth.',
    collectionId: 'c_city',
  ),
  Product(
    id: 'p14',
    title: 'Portsmouth City Bookmark',
    price: 3.00,
    image: 'assets/images/p14.jpg',
    description: 'Keep your place in your textbooks with this city bookmark.',
    collectionId: 'c_merch',
  ),
  Product(
    id: 'p15',
    title: 'Portsmouth City Notebook',
    price: 7.50,
    image: 'assets/images/p15.jpg',
    description: 'A5 notebook perfect for lectures and taking notes.',
    collectionId: 'c_merch',
  ),
  Product(
    id: 'p16',
    title: 'Portsmouth City Water Bottle',
    price: 15.00,
    image: 'assets/images/p16.jpg',
    description: 'Stay hydrated with this reusable Portsmouth City water bottle.',
    collectionId: 'c_city',
  ),
  Product(
    id: 'p17',
    title: 'Portsmouth City Coaster',
    price: 4.50,
    image: 'assets/images/p17.jpg',
    description: 'Protect your desk with this stylish city coaster.',
    collectionId: 'c_city',
  ),
  Product(
    id: 'p18',
    title: 'Portsmouth City Keyring',
    price: 6.75,
    image: 'assets/images/p18.jpg',
    description: 'Metal keyring featuring the Portsmouth City design.',
    collectionId: 'c_merch',
  ),

  // --- HALLOWEEN (c_halloween) ---
  Product(
    id: 'h1',
    title: 'Spooky Tee',
    price: 15.00,
    image: 'assets/images/spooky.jpg',
    description: 'Scary good comfort.',
    collectionId: 'c_halloween',
  ),

  // --- PRIDE (c_pride) ---
  Product(
    id: 'pr1',
    title: 'Pride Pin',
    price: 3.00,
    image: 'assets/images/pride.jpg',
    description: 'Wear your pride.',
    collectionId: 'c_pride',
  ),

  // --- GRADUATION (c_grad) ---
  Product(
    id: 'g1',
    title: 'Graduation Bear',
    price: 12.00,
    image: 'assets/images/bear.jpg',
    description: 'A cute bear for your big day.',
    collectionId: 'c_grad',
  ),
];

// Simple filter logic
List<Product> getProductsByCollection(String collectionId) {
  // If we want "Clothing" to include Grad Hoodies, we can modify logic here
  // For now, it matches exact collectionId OR includes logic for overlaps
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