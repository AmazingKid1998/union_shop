class Product {
  final String id;
  final String title;
  final double price; // The current (sale) price
  final double? oldPrice; // The original price (Null if not on sale)
  final String image;
  final String description;
  final String collectionId;

  Product({
    required this.id,
    required this.title,
    required this.price,
    this.oldPrice, // Optional
    required this.image,
    required this.description,
    required this.collectionId,
  });
}