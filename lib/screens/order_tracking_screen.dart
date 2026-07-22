import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../widgets/organic_background.dart';
import '../theme/app_design.dart';
import '../models/order_model.dart';
import '../data/service_locator.dart';

const List<String> _statusFlow = [
  'placed',
  'confirmed',
  'out_for_delivery',
  'delivered',
];

class OrderTrackingScreen extends StatefulWidget {
  final int orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  Order? _order;
  bool _isLoading = true;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _fetchOrder();
    _pollTimer = Timer.periodic(const Duration(seconds: 10), (_) => _fetchOrder(silent: true));
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchOrder({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final order = await locator.orderRepository.getOrder(widget.orderId);
      if (!mounted) return;
      setState(() => _order = order);
      if (order.isFinal) _pollTimer?.cancel();
    } catch (e) {
      if (mounted && !silent) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading order: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted && !silent) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = _order;

    return Scaffold(
      body: Stack(
        children: [
          const OrganicBackground(),
          SafeArea(
            child: _isLoading || order == null
                ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
                : RefreshIndicator(
                    onRefresh: _fetchOrder,
                    child: ListView(
                      padding: EdgeInsets.all(AppDesign.padding),
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Order #${order.id}",
                              style: AppDesign.headingLarge(context).copyWith(fontSize: 26),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.status == 'cancelled'
                                    ? "Order Cancelled"
                                    : order.isFinal
                                        ? "Delivered"
                                        : "Arriving in ~${order.etaMinutes} min",
                                style: AppDesign.headingMedium(context).copyWith(fontSize: 20),
                              ),
                              const SizedBox(height: 20),
                              if (order.status != 'cancelled') _StatusStepper(status: order.status),
                              const SizedBox(height: 8),
                              Text(
                                "Delivering to ${order.deliveryAddress}",
                                style: AppDesign.bodySmall(context),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text("Items", style: AppDesign.headingMedium(context).copyWith(fontSize: 18)),
                        const SizedBox(height: 12),
                        ...order.items.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${item.name} × ${item.quantity}",
                                      style: AppDesign.bodyMedium(context),
                                    ),
                                  ),
                                  Text(
                                    "₹${item.lineTotal.toStringAsFixed(2)}",
                                    style: AppDesign.bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )),
                        const Divider(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total", style: AppDesign.headingMedium(context).copyWith(fontSize: 18)),
                            Text(
                              "₹${order.total.toStringAsFixed(2)}",
                              style: AppDesign.headingMedium(context).copyWith(fontSize: 18, color: AppColors.accent),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _StatusStepper extends StatelessWidget {
  final String status;

  const _StatusStepper({required this.status});

  @override
  Widget build(BuildContext context) {
    final currentIndex = _statusFlow.indexOf(status);

    return Row(
      children: List.generate(_statusFlow.length * 2 - 1, (i) {
        if (i.isOdd) {
          final passed = (i ~/ 2) < currentIndex;
          return Expanded(
            child: Container(
              height: 2,
              color: passed ? AppColors.accent : AppColors.surfaceGrey,
            ),
          );
        }
        final stepIndex = i ~/ 2;
        final isDone = stepIndex <= currentIndex;
        return Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone ? AppColors.accent : AppColors.surfaceGrey,
          ),
        );
      }),
    );
  }
}
