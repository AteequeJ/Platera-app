import '../../models/order_model.dart';
import '../api_client.dart';

class OrderService {
  final ApiClient _apiClient;

  OrderService(this._apiClient);

  Future<Order> checkout(String deliveryAddress, String phone) async {
    final response = await _apiClient.dio.post(
      'orders/checkout',
      data: {'deliveryAddress': deliveryAddress, 'phone': phone},
    );
    return Order.fromJson(response.data['data']);
  }

  Future<List<Order>> getOrders() async {
    final response = await _apiClient.dio.get('orders');
    return (response.data['data'] as List)
        .map((o) => Order.fromJson(o))
        .toList();
  }

  Future<Order> getOrder(int id) async {
    final response = await _apiClient.dio.get('orders/$id');
    return Order.fromJson(response.data['data']);
  }
}
