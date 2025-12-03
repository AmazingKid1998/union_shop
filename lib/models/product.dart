class Product {
  final String id;
  final String title;
  final double price;
  final double? oldPrice;
  final String image;
  final String description;
  final String collectionId;
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

  // Convert a Product into a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'oldPrice': oldPrice,
      'image': image,
      'description': description,
      'collectionId': collectionId,
      'variants': variants,
    };
  }

  // Create a Product from a Map (JSON)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      oldPrice: json['oldPrice'] != null ? (json['oldPrice'] as num).toDouble() : null,
      image: json['image'],
      description: json['description'],
      collectionId: json['collectionId'],
      variants: json['variants'] != null ? Map<String, String>.from(json['variants']) : null,
    );
  }
}