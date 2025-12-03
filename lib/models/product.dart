class Product {
  final String id;
  final String title;
  final double price;
  final double? oldPrice;
  final String image;
  final String description;
  // CHANGED: From single String to List<String>
  final List<String> collectionIds;
  final Map<String, String>? variants;

  Product({
    required this.id,
    required this.title,
    required this.price,
    this.oldPrice,
    required this.image,
    required this.description,
    required this.collectionIds,
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
      'collectionIds': collectionIds, // Save list
      'variants': variants,
    };
  }

  // Create a Product from a Map (JSON)
  factory Product.fromJson(Map<String, dynamic> json) {
    // Handle migration: if JSON has old 'collectionId', wrap it in a list
    List<String> parsedIds = [];
    if (json['collectionIds'] != null) {
      parsedIds = List<String>.from(json['collectionIds']);
    } else if (json['collectionId'] != null) {
      parsedIds = [json['collectionId']];
    }

    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      oldPrice: json['oldPrice'] != null ? (json['oldPrice'] as num).toDouble() : null,
      image: json['image'],
      description: json['description'],
      collectionIds: parsedIds,
      variants: json['variants'] != null ? Map<String, String>.from(json['variants']) : null,
    );
  }
}