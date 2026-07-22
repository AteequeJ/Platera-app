import '../../models/order_model.dart';
import '../services/order_service.dart';

class OrderRepository {
  final OrderService _orderService;

  OrderRepository(this._orderService);

  Future<Order> checkout(String deliveryAddress, String phone) async {
    return await _orderService.checkout(deliveryAddress, phone);
  }

  Future<List<Order>> getOrders() async {
    return await _orderService.getOrders();
  }

  Future<Order> getOrder(int id) async {
    return await _orderService.getOrder(id);
  }
}
