import '../models/product.dart';

// --- FULL DATASET ---
final List<Product> _allProducts = [
  // 3. CLASSIC HOODIE (Clothing)
  Product(
    id: 'p_classic_hoodie',
    title: 'Classic Hoodie',
    price: 25.00,
    oldPrice: 35.00, // ON SALE
    image: 'assets/images/classichoodie_grey.webp', 
    description: 'Our best selling Classic Hoodie comes in 3 great colours! 100% Cotton.',
    collectionId: 'c_clothing',
    variants: {
      'Grey': 'assets/images/classichoodie_grey.webp',
      'Navy': 'assets/images/classichoodie_navy.webp',
      'Purple': 'assets/images/classichoodie_purple.webp',
    },
  ),

  // 4. ESSENTIAL T-SHIRT (Clothing)
  Product(
    id: 'p_essential_tee',
    title: 'Essential T-Shirt',
    price: 12.00,
    image: 'assets/images/essential_blue.webp', 
    description: 'A wardrobe staple. Available in Blue and Green.',
    collectionId: 'c_clothing',
    variants: {
      'Blue': 'assets/images/essential_blue.webp',
      'Green': 'assets/images/essential_green.webp',
    },
  ),

  // 6. SIGNATURE RANGE (Clothing)
  Product(
    id: 'p_signature',
    title: 'Signature T-Shirt',
    price: 35.00,
    image: 'assets/images/signature_blue.webp',
    description: 'Premium heavyweight t-shirt from our Signature collection.',
    collectionId: 'c_clothing',
    variants: {
      'Blue': 'assets/images/signature_blue.webp',
      'Sand': 'assets/images/signature_sand.webp',
    },
  ),

  // 5. HALLOWEEN (Halloween)
  Product(
    id: 'p_halloween',
    title: 'Spooky Tote Bag',
    price: 15.00,
    image: 'assets/images/halloween_ghost.webp',
    description: 'Limited edition Halloween tote bag. Choose your spook!',
    collectionId: 'c_halloween',
    variants: {
      'Ghost Style': 'assets/images/halloween_ghost.webp',
      'Boo Style': 'assets/images/halloween_boo.webp',
    },
  ),

  // 1. GRADUATION (Graduation)
  Product(
    id: 'p_grad_1',
    title: 'Graduation Pin',
    price: 15.00,
    image: 'assets/images/graduation_p1.webp',
    description: 'Signature graduation pin for your big day.',
    collectionId: 'c_grad',
  ),
  Product(
    id: 'p_grad_2',
    title: 'Graduation Hoodie 2025',
    price: 35.00,
    image: 'assets/images/graduation_p2.webp',
    description: 'Official Class of 2025 Hoodie.',
    collectionId: 'c_grad',
  ),

  // --- NEW: PORTSMOUTH CITY COLLECTION ---
  Product(
    id: 'p_city_postcard',
    title: 'Portsmouth City Postcard',
    price: 1.00,
    image: 'assets/images/city_postcard.webp', // Ensure you rename your uploaded file to this
    description: 'Send a piece of Portsmouth to friends and family with this illustrated postcard.',
    collectionId: 'c_city',
  ),
  Product(
    id: 'p_city_magnet',
    title: 'Portsmouth City Magnet',
    price: 4.50,
    image: 'assets/images/city_magnet.webp', // Ensure you rename your uploaded file to this
    description: 'Decorate your fridge with this classic Portsmouth City magnet.',
    collectionId: 'c_city',
  ),

  // 2. MERCHANDISE (Merchandise)
  Product(
    id: 'p_merch_1',
    title: 'Lanyard',
    price: 5.00,     
    oldPrice: 8.00,  
    image: 'assets/images/merchendise_p1.webp',
    description: 'University branded lanyard.',
    collectionId: 'c_merch',
  ),
  Product(
    id: 'p_merch_2',
    title: 'Uni Pen',
    price: 3.00,     
    oldPrice: 5.00,  
    image: 'assets/images/merchendise_p2.webp',
    description: 'Branded Pen',
    collectionId: 'c_merch',
  ),
  Product(
    id: 'p_merch_3',
    title: 'Metal Water Bottle',
    price: 12.00,
    image: 'assets/images/merchendise_p3.webp',
    description: 'Keep your drinks cool.',
    collectionId: 'c_merch',
  ),
  Product(
    id: 'p_merch_4',
    title: 'Notebook',
    price: 4.00,
    image: 'assets/images/merchendise_p4.webp',
    description: 'Uni branded notebook',
    collectionId: 'c_merch',
  ),
  Product(
    id: 'p_merch_5',
    title: 'Tie',
    price: 3.00,
    image: 'assets/images/merchendise_p5.webp',
    description: 'University branded tie',
    collectionId: 'c_merch',
  ),
];

class ProductRepository {
  Future<List<Product>> getAllProducts() async {
    return _allProducts;
  }

  Product getProductById(String id) {
    return _allProducts.firstWhere((p) => p.id == id, orElse: () => _allProducts.first);
  }

  List<Product> getProductsByCollection(String collectionId) {
    if (collectionId == 'c_clothing') {
       return _allProducts.where((p) => p.collectionId == 'c_clothing').toList();
    }
    return _allProducts.where((p) => p.collectionId == collectionId).toList();
  }
  
  List<Product> getSaleProducts() {
    return _allProducts.where((p) => p.oldPrice != null).toList();
  }
}