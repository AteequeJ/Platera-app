import 'package:flutter/material.dart';
import '../widgets/organic_background.dart';
import '../widgets/recipe_widgets.dart';
import '../theme/app_design.dart';
import '../data/service_locator.dart';
import 'order_tracking_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final address = _addressController.text.trim();
    final phone = _phoneController.text.trim();

    if (address.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both a delivery address and phone number")),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final order = await locator.orderRepository.checkout(address, phone);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OrderTrackingScreen(orderId: order.id)),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Checkout failed: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const OrganicBackground(),
          SafeArea(
            child: ListView(
              padding: EdgeInsets.all(AppDesign.padding),
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Checkout",
                      style: AppDesign.headingLarge(context).copyWith(fontSize: 26),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                AppTextField(
                  label: "Delivery Address",
                  hint: "Flat, street, area, city",
                  icon: Icons.location_on_outlined,
                  controller: _addressController,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: "Phone Number",
                  hint: "e.g. 9876543210",
                  icon: Icons.phone_outlined,
                  controller: _phoneController,
                ),
                const SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _isSubmitting ? null : _submit,
                      borderRadius: BorderRadius.circular(100),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Center(
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : Text(
                                  "Place Order",
                                  style: AppDesign.bodyMedium(context)
                                      .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
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
