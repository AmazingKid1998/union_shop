import '../models/product.dart';

// --- FULL DATASET BASED ON YOUR IMAGES ---
final List<Product> _allProducts = [
  // 3. CLASSIC HOODIE (Clothing) - 3 Colours
  Product(
    id: 'p_classic_hoodie',
    title: 'Classic Hoodie',
    price: 25.00,
    image: 'assets/images/classichoodie_grey.webp', // Default
    description: 'Our best selling Classic Hoodie comes in 3 great colours! 100% Cotton.',
    collectionId: 'c_clothing',
    variants: {
      'Grey': 'assets/images/classichoodie_grey.webp',
      'Navy': 'assets/images/classichoodie_navy.webp',
      'Purple': 'assets/images/classichoodie_purple.webp',
    },
  ),

  // 4. ESSENTIAL T-SHIRT (Clothing) - 2 Colours
  Product(
    id: 'p_essential_tee',
    title: 'Essential T-Shirt',
    price: 12.00,
    image: 'assets/images/essential_blue.webp', // Default
    description: 'A wardrobe staple. Available in Blue and Green.',
    collectionId: 'c_clothing',
    variants: {
      'Blue': 'assets/images/essential_blue.webp',
      'Green': 'assets/images/essential_green.webp',
    },
  ),

  // 6. SIGNATURE RANGE (Clothing) - 2 Colours
  Product(
    id: 'p_signature',
    title: 'Signature Hoodie',
    price: 35.00,
    image: 'assets/images/signature_blue.webp',
    description: 'Premium heavyweight hoodie from our Signature collection.',
    collectionId: 'c_clothing',
    variants: {
      'Blue': 'assets/images/signature_blue.webp',
      'Sand': 'assets/images/signature_sand.webp',
    },
  ),

  // 5. HALLOWEEN (Halloween) - 2 Styles
  Product(
    id: 'p_halloween',
    title: 'Spooky Tee',
    price: 15.00,
    image: 'assets/images/halloween_ghost.webp',
    description: 'Limited edition Halloween tees. Choose your spook!',
    collectionId: 'c_halloween',
    variants: {
      'Ghost Style': 'assets/images/halloween_ghost.webp',
      'Boo Style': 'assets/images/halloween_boo.webp',
    },
  ),

  // 1. GRADUATION (Graduation) - Dummy Products for each image
  Product(
    id: 'p_grad_1',
    title: 'Graduation Bear',
    price: 15.00,
    image: 'assets/images/graduation_p1.webp',
    description: 'Cute graduation bear with gown.',
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

  // 2. MERCHANDISE (Merchandise) - Dummy Products for each image
  Product(
    id: 'p_merch_1',
    title: 'Union Mug',
    price: 8.00,
    image: 'assets/images/merchendise_p1.webp',
    description: 'Ceramic mug with Union logo.',
    collectionId: 'c_merch',
  ),
  Product(
    id: 'p_merch_2',
    title: 'Notebook A5',
    price: 5.00,
    image: 'assets/images/merchendise_p2.webp',
    description: 'Lined notebook for lectures.',
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
    title: 'Tote Bag',
    price: 4.00,
    image: 'assets/images/merchendise_p4.webp',
    description: 'Cotton tote bag.',
    collectionId: 'c_merch',
  ),
  Product(
    id: 'p_merch_5',
    title: 'Lanyard',
    price: 3.00,
    image: 'assets/images/merchendise_p5.webp',
    description: 'University branded lanyard.',
    collectionId: 'c_merch',
  ),
  
  // CATEGORY PLACEHOLDERS (Keep these for the Shop Page grid images if needed)
  Product(id: 'cat_clothing', title: 'Clothing Cat', price: 0, image: 'assets/images/clothing_cat.jpg', description: '', collectionId: 'hidden'),
  Product(id: 'cat_merch', title: 'Merch Cat', price: 0, image: 'assets/images/merch_cat.jpg', description: '', collectionId: 'hidden'),
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