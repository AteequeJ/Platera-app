class Category {
  Category({required this.id, required this.name, required this.createdAt});

  final int? id;
  final String? name;
  final DateTime? createdAt;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"],
      name: json["name"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
    );
  }
}

class Unit {
  Unit({required this.id, required this.name, required this.shortName});

  final int? id;
  final String? name;
  final String? shortName;

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json["id"],
      name: json["name"],
      shortName: json["short_name"],
    );
  }
}

class StockUpdate {
  final double amount;
  final String
  type; // 'add' or 'remove' based on common patterns, Postman shows 'add'

  StockUpdate({required this.amount, required this.type});

  Map<String, dynamic> toJson() => {'amount': amount, 'type': type};
}

class StockHistory {
  final int id;
  final int itemId;
  final double amount;
  final String type;
  final DateTime createdAt;

  StockHistory({
    required this.id,
    required this.itemId,
    required this.amount,
    required this.type,
    required this.createdAt,
  });

  factory StockHistory.fromJson(Map<String, dynamic> json) {
    return StockHistory(
      id: json['id'] ?? 0,
      itemId: json['itemId'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      type: json['type'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
