class CartItem {
  final int id;
  final int userId;
  final int productId;
  final String name;
  final int unitId;
  final double price;
  final int quantity;
  final String source; // 'manual' | 'recipe_missing'
  final String? recipeName;
  final DateTime? createdAt;

  CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.name,
    required this.unitId,
    required this.price,
    required this.quantity,
    this.source = 'manual',
    this.recipeName,
    this.createdAt,
  });

  double get lineTotal => price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      name: json['name'] ?? '',
      unitId: json['unit_id'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      source: json['source'] ?? 'manual',
      recipeName: json['recipe_name'],
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
    );
  }
}

class CartData {
  final List<CartItem> items;
  final double subtotal;

  CartData({required this.items, required this.subtotal});

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      items: (json['items'] as List? ?? [])
          .map((i) => CartItem.fromJson(i))
          .toList(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
    );
  }
}

class FromRecipeResult {
  final List<CartItem> added;
  final List<String> unmatched;

  FromRecipeResult({required this.added, required this.unmatched});

  factory FromRecipeResult.fromJson(Map<String, dynamic> json) {
    return FromRecipeResult(
      added: (json['added'] as List? ?? [])
          .map((i) => CartItem.fromJson(i))
          .toList(),
      unmatched: List<String>.from(json['unmatched'] ?? []),
    );
  }
}
