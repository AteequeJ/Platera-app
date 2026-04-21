class ItemsModel {
  ItemsModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.quantity,
    required this.createdAt,
    required this.categoryId,
    required this.unitId,
    required this.minQuantity,
  });

  final int? id;
  final int? userId;
  final String? name;
  final int? quantity;
  final DateTime? createdAt;
  final int? categoryId;
  final int? unitId;
  final String? minQuantity;

  factory ItemsModel.fromJson(Map<String, dynamic> json) {
    return ItemsModel(
      id: json["id"],
      userId: json["user_id"],
      name: json["name"],
      quantity: json["quantity"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      categoryId: json["category_id"],
      unitId: json["unit_id"],
      minQuantity: json["min_quantity"],
    );
  }

  bool get isAvailable => (quantity ?? 0) > 0;
  String get icon => "📦"; // Default icon for all items
  String get unit {
    // Basic mapping for common units, can be expanded or fetched from Units API
    switch (unitId) {
      case 1: return "pcs";
      case 2: return "kg";
      case 3: return "ml";
      default: return "pcs";
    }
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "quantity": quantity,
    "category_id": categoryId,
    "unit_id": unitId,
    "min_quantity": minQuantity,
  };
}
