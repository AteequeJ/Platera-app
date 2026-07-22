import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../widgets/organic_background.dart';
import '../theme/app_design.dart';
import '../models/order_model.dart';
import '../data/service_locator.dart';
import 'order_tracking_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() => _isLoading = true);
    try {
      final orders = await locator.orderRepository.getOrders();
      if (mounted) setState(() => _orders = orders);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading orders: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const OrganicBackground(),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(AppDesign.padding),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Your Orders",
                        style: AppDesign.headingLarge(context).copyWith(fontSize: 26),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
                      : _orders.isEmpty
                          ? Center(
                              child: Text(
                                "No orders yet",
                                style: AppDesign.bodyMedium(context),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _fetchOrders,
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: AppDesign.padding),
                                itemCount: _orders.length,
                                itemBuilder: (context, index) {
                                  final order = _orders[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: GestureDetector(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OrderTrackingScreen(orderId: order.id),
                                        ),
                                      ),
                                      child: GlassCard(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Order #${order.id}",
                                                    style: AppDesign.bodyMedium(context)
                                                        .copyWith(fontWeight: FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(order.statusLabel, style: AppDesign.bodySmall(context)),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              "₹${order.total.toStringAsFixed(2)}",
                                              style: AppDesign.bodyMedium(context)
                                                  .copyWith(fontWeight: FontWeight.bold, color: AppColors.accent),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
