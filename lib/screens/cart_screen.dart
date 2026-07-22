import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../widgets/organic_background.dart';
import '../theme/app_design.dart';
import '../models/cart_model.dart';
import '../data/service_locator.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartData? _cart;
  bool _isLoading = true;
  final Set<int> _pendingItemIds = {};

  @override
  void initState() {
    super.initState();
    _fetchCart();
  }

  Future<void> _fetchCart() async {
    setState(() => _isLoading = true);
    try {
      final cart = await locator.cartRepository.getCart();
      if (mounted) setState(() => _cart = cart);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading cart: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateQuantity(CartItem item, int newQuantity) async {
    if (newQuantity < 1) return;
    setState(() => _pendingItemIds.add(item.id));
    try {
      await locator.cartRepository.updateItem(item.id, newQuantity);
      await _fetchCart();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Couldn't update quantity: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) setState(() => _pendingItemIds.remove(item.id));
    }
  }

  Future<void> _removeItem(CartItem item) async {
    setState(() => _pendingItemIds.add(item.id));
    try {
      await locator.cartRepository.deleteItem(item.id);
      await _fetchCart();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Couldn't remove item: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) setState(() => _pendingItemIds.remove(item.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _cart?.items ?? [];

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
                        "Your Cart",
                        style: AppDesign.headingLarge(context).copyWith(fontSize: 26),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
                      : items.isEmpty
                          ? _EmptyCart()
                          : RefreshIndicator(
                              onRefresh: _fetchCart,
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: AppDesign.padding),
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: _CartItemTile(
                                      item: item,
                                      isPending: _pendingItemIds.contains(item.id),
                                      onIncrement: () => _updateQuantity(item, item.quantity + 1),
                                      onDecrement: () => _updateQuantity(item, item.quantity - 1),
                                      onRemove: () => _removeItem(item),
                                    ),
                                  );
                                },
                              ),
                            ),
                ),
                if (!_isLoading && items.isNotEmpty)
                  _CheckoutBar(
                    subtotal: _cart?.subtotal ?? 0,
                    onCheckout: () async {
                      final placed = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                      );
                      if (placed == true) _fetchCart();
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 56, color: AppColors.textBody(context).withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            "Your cart is empty",
            style: AppDesign.bodyMedium(context).copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            "Add missing ingredients from a recipe to get started",
            textAlign: TextAlign.center,
            style: AppDesign.bodySmall(context),
          ),
        ],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final bool isPending;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartItemTile({
    required this.item,
    required this.isPending,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Opacity(
        opacity: isPending ? 0.5 : 1,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: AppDesign.bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (item.source == 'recipe_missing' && item.recipeName != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      "For ${item.recipeName}",
                      style: AppDesign.bodySmall(context).copyWith(fontSize: 11),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    "₹${item.lineTotal.toStringAsFixed(2)}",
                    style: AppDesign.bodyMedium(context).copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                _QuantityButton(icon: Icons.remove, onTap: isPending ? null : onDecrement),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text("${item.quantity}", style: AppDesign.bodyMedium(context)),
                ),
                _QuantityButton(icon: Icons.add, onTap: isPending ? null : onIncrement),
              ],
            ),
            IconButton(
              onPressed: isPending ? null : onRemove,
              icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.surfaceGrey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  final double subtotal;
  final VoidCallback onCheckout;

  const _CheckoutBar({required this.subtotal, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(AppDesign.padding, 16, AppDesign.padding, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Subtotal", style: AppDesign.bodySmall(context)),
                Text(
                  "₹${subtotal.toStringAsFixed(2)}",
                  style: AppDesign.headingMedium(context).copyWith(fontSize: 20),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onCheckout,
                borderRadius: BorderRadius.circular(100),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Text(
                    "Checkout",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
