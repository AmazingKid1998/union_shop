class Product {
  final String id;
  final String title;
  final double price;
  final double? oldPrice;
  final String image; // Default image
  final String description;
  final String collectionId;
  
  // New: Map of Variant Name -> Image Path
  // e.g., {'Grey': 'assets/images/grey.webp', 'Blue': 'assets/images/blue.webp'}
  final Map<String, String>? variants; 

  Product({
    required this.id,
    required this.title,
    required this.price,
    this.oldPrice,
    required this.image,
    required this.description,
    required this.collectionId,
    this.variants,
  });
}