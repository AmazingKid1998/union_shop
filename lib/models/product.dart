class Product {
  final String id;
  final String title;
  final double price;
  final String image; // We will use a placeholder URL
  final String description;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
  });
}
class Collection {
  final String id;
  final String title;
  final String image;

  Collection({required this.id, required this.title, required this.image});
}