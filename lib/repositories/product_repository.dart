import '../models/product.dart';

// --- FULL DATASET ---
final List<Product> _allProducts = [
  // 3. CLASSIC HOODIE (Clothing)
  Product(
    id: 'p_classic_hoodie',
    title: 'Classic Hoodie',
    price: 25.00,
    oldPrice: 35.00, 
    image: 'assets/images/classichoodie_grey.webp', 
    description: 'Our best selling Classic Hoodie comes in 3 great colours! 100% Cotton.',
    collectionIds: ['c_clothing'], // List format
    variants: {
      'Grey': 'assets/images/classichoodie_grey.webp',
      'Navy': 'assets/images/classichoodie_navy.webp',
      'Purple': 'assets/images/classichoodie_purple.webp',
    },
  ),

  // 4. ESSENTIAL T-SHIRT (Clothing + Essential) <--- UPDATED HERE
  Product(
    id: 'p_essential_tee',
    title: 'Essential T-Shirt',
    price: 12.00,
    image: 'assets/images/essential_blue.webp', 
    description: 'A wardrobe staple. Available in Blue and Green.',
    // MAGIC HAPPENS HERE: Two categories!
    collectionIds: ['c_clothing', 'c_essential'], 
    variants: {
      'Blue': 'assets/images/essential_blue.webp',
      'Green': 'assets/images/essential_green.webp',
    },
  ),

  // 6. SIGNATURE RANGE (Clothing + Signature)
  Product(
    id: 'p_signature',
    title: 'Signature T-Shirt',
    price: 35.00,
    image: 'assets/images/signature_blue.webp',
    description: 'Premium heavyweight t-shirt from our Signature collection.',
    collectionIds: ['c_clothing', 'c_signature'],
    variants: {
      'Blue': 'assets/images/signature_blue.webp',
      'Sand': 'assets/images/signature_sand.webp',
    },
  ),

  // 5. HALLOWEEN
  Product(
    id: 'p_halloween',
    title: 'Spooky Tote Bag',
    price: 15.00,
    image: 'assets/images/halloween_ghost.webp',
    description: 'Limited edition Halloween tote bag.',
    collectionIds: ['c_halloween'],
    variants: {
      'Ghost Style': 'assets/images/halloween_ghost.webp',
      'Boo Style': 'assets/images/halloween_boo.webp',
    },
  ),

  // 1. GRADUATION
  Product(
    id: 'p_grad_1',
    title: 'Graduation Pin',
    price: 15.00,
    image: 'assets/images/graduation_p1.webp',
    description: 'Signature graduation pin.',
    collectionIds: ['c_grad'],
  ),
  Product(
    id: 'p_grad_2',
    title: 'Graduation Hoodie 2025',
    price: 35.00,
    image: 'assets/images/graduation_p2.webp',
    description: 'Official Class of 2025 Hoodie.',
    collectionIds: ['c_grad', 'c_clothing'], // Also in Clothing
  ),

  // 2. MERCHANDISE
  Product(
    id: 'p_city_postcard',
    title: 'Portsmouth City Postcard',
    price: 1.00,
    image: 'assets/images/city_postcard.webp',
    description: 'Illustrated postcard.',
    collectionIds: ['c_city', 'c_merch'],
  ),
  Product(
    id: 'p_city_magnet',
    title: 'Portsmouth City Magnet',
    price: 4.50,
    image: 'assets/images/city_magnet.webp',
    description: 'Classic magnet.',
    collectionIds: ['c_city', 'c_merch'],
  ),
  Product(
    id: 'p_merch_1',
    title: 'Lanyard',
    price: 5.00, oldPrice: 8.00,  
    image: 'assets/images/merchendise_p1.webp',
    description: 'University branded lanyard.',
    collectionIds: ['c_merch'],
  ),
  Product(
    id: 'p_merch_2',
    title: 'Uni Pen',
    price: 3.00, oldPrice: 5.00,  
    image: 'assets/images/merchendise_p2.webp',
    description: 'Branded Pen',
    collectionIds: ['c_merch'],
  ),
  Product(
    id: 'p_merch_3',
    title: 'Metal Water Bottle',
    price: 12.00,
    image: 'assets/images/merchendise_p3.webp',
    description: 'Keep your drinks cool.',
    collectionIds: ['c_merch'], // NOTE: Fix below, this should be ['c_merch']
  ),
];

// Correcting the helper method to filter by LIST containment
class ProductRepository {
  Future<List<Product>> getAllProducts() async {
    // Quick fix for any typo in list definition above
    // Ensure all collectionIds are Lists
    return _allProducts;
  }

  Product getProductById(String id) {
    return _allProducts.firstWhere((p) => p.id == id, orElse: () => _allProducts.first);
  }

  // UPDATED LOGIC: Check if the product's list contains the requested ID
  List<Product> getProductsByCollection(String collectionId) {
    return _allProducts.where((p) => p.collectionIds.contains(collectionId)).toList();
  }
  
  List<Product> getSaleProducts() {
    return _allProducts.where((p) => p.oldPrice != null).toList();
  }
}