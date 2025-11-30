class Product {
  final String id;
  final String title;
  final double price;
  final String image;
  final String description;
  final String collectionId; // Used for filtering categories

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.collectionId,
  });
}