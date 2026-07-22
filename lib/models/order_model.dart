class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final String name;
  final int unitId;
  final double price;
  final int quantity;
  final double lineTotal;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.name,
    required this.unitId,
    required this.price,
    required this.quantity,
    required this.lineTotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      name: json['name'] ?? '',
      unitId: json['unit_id'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      lineTotal: (json['line_total'] ?? 0).toDouble(),
    );
  }
}

// One of: placed, confirmed, out_for_delivery, delivered, cancelled
class Order {
  final int id;
  final int userId;
  final String status;
  final String deliveryAddress;
  final String phone;
  final double total;
  final int etaMinutes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.userId,
    required this.status,
    required this.deliveryAddress,
    required this.phone,
    required this.total,
    this.etaMinutes = 20,
    this.createdAt,
    this.updatedAt,
    this.items = const [],
  });

  String get statusLabel {
    switch (status) {
      case 'placed':
        return 'Order Placed';
      case 'confirmed':
        return 'Confirmed';
      case 'out_for_delivery':
        return 'Out for Delivery';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  bool get isFinal => status == 'delivered' || status == 'cancelled';

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      status: json['status'] ?? 'placed',
      deliveryAddress: json['delivery_address'] ?? '',
      phone: json['phone'] ?? '',
      total: (json['total'] ?? 0).toDouble(),
      etaMinutes: json['eta_minutes'] ?? 20,
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
      items: (json['items'] as List? ?? [])
          .map((i) => OrderItem.fromJson(i))
          .toList(),
    );
  }
}
