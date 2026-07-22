class Product {
  final int id;
  final String name;
  final int? categoryId;
  final int unitId;
  final double price;
  final bool inStock;
  final String? imageUrl;
  final DateTime? createdAt;

  Product({
    required this.id,
    required this.name,
    this.categoryId,
    required this.unitId,
    required this.price,
    this.inStock = true,
    this.imageUrl,
    this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      categoryId: json['category_id'],
      unitId: json['unit_id'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      inStock: json['in_stock'] ?? true,
      imageUrl: json['image_url'],
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
    );
  }
}
