import 'package:flutter/material.dart';
import 'package:platera_app/models/pantry_models.dart';
import '../theme/app_design.dart';
import '../models/ingredient.dart';
import '../data/service_locator.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String searchQuery = "";
  bool _isUnitLoading = false;
  // final List<String> _units = [
  //   "pcs",
  //   "kg",
  //   "g",
  //   "ml",
  //   "l",
  //   "can",
  //.  "bag",
  //   "box",
  //   "block",
  //   "fillet",
  //   "pack",
  //   "cup",
  //   "spoon",
  // ];

  List<ItemsModel> _inventory = [];
  List<Unit> _units = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInventory();
    _fetchUnit();
  }

  Future<void> _fetchUnit() async {
    setState(() {
      _isUnitLoading = true;
    });
    try {
      final units = await locator.pantryRepository.getUnits();
      setState(() {
        _units = units;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching units: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) setState(() => _isUnitLoading = false);
    }
  }

  Future<void> _fetchInventory() async {
    setState(() => _isLoading = true);
    try {
      final items = await locator.pantryRepository.getInventory();
      setState(() => _inventory = items);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching pantry: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAddItemSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddItemSheet(
        units: _units,
        isUnitLoading: _isUnitLoading,
        onAdd: (name, qty, unit) async {
          final newItem = ItemsModel(
            name: name,
            quantity: qty,
            id: 0,
            userId: 0,
            createdAt: DateTime.now(),
            categoryId: 1,
            unitId: unit.id ?? 1,
            minQuantity: '1',
          );

          try {
            await locator.pantryRepository.addIngredient(newItem);
            await _fetchInventory();
            if (mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Added $name to pantry"),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.accent,
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error adding item: ${e.toString()}")),
              );
            }
          }
        },
      ),
    );
  }

  Future<void> _updateQuantity(ItemsModel ingredient, int newQty) async {
    if (ingredient.id == null) return;

    final currentQty = ingredient.quantity ?? 0;
    if (newQty == currentQty) return;

    try {
      await locator.pantryRepository.updateStock(
        ingredient.id!,
        (newQty - currentQty).abs().toDouble(),
        newQty > currentQty,
      );
      await _fetchInventory();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating quantity: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ItemsModel> filteredIngredients = _inventory
        .where(
          (i) =>
              (i.name ?? "").toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.primary,
            ),
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surfaceGrey,
              shape: const CircleBorder(),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "My Pantry",
          style: AppDesign.bodyMedium(
            context,
          ).copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemSheet,
        backgroundColor: AppColors.primary,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          // Search Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDesign.padding),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceGrey,
                borderRadius: BorderRadius.circular(100),
              ),
              child: TextField(
                onChanged: (val) => setState(() => searchQuery = val),
                decoration: InputDecoration(
                  hintText: "Search pantry items",
                  hintStyle: AppDesign.bodyMedium(context).copyWith(
                    color: AppColors.textBody(context).withOpacity(0.3),
                  ),
                  icon: const Icon(Icons.search, size: 20),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredIngredients.isEmpty
                ? Center(
                    child: Text(
                      "No items found in pantry",
                      style: AppDesign.bodyMedium(context),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDesign.padding,
                    ),
                    itemCount: filteredIngredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = filteredIngredients[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _IngredientItem(
                          ingredient: ingredient,
                          onUpdate: (newQty) =>
                              _updateQuantity(ingredient, newQty),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _AddItemSheet extends StatefulWidget {
  final List<Unit> units;
  final bool isUnitLoading;
  final Function(String, int, Unit) onAdd;

  const _AddItemSheet({
    required this.units,
    required this.isUnitLoading,
    required this.onAdd,
  });

  @override
  State<_AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<_AddItemSheet> {
  final TextEditingController _nameController = TextEditingController();
  int _qty = 1;
  Unit? _selectedUnit;

  @override
  void initState() {
    super.initState();
    if (widget.units.isNotEmpty) {
      _selectedUnit = widget.units.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        top: 32,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        color: AppColors.background(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Add New Item",
                style: AppDesign.headingMedium(
                  context,
                ).copyWith(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surfaceGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "Item Name",
            style: AppDesign.bodySmall(context).copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textBody(context).withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "e.g. Avocado",
              filled: true,
              fillColor: AppColors.surfaceGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Quantity",
                      style: AppDesign.bodySmall(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBody(context).withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceGrey,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () => setState(() {
                              if (_qty > 1) _qty--;
                            }),
                            icon: const Icon(Icons.remove_circle_outline),
                            color: AppColors.primary,
                          ),
                          Text(
                            "$_qty",
                            style: AppDesign.bodyMedium(
                              context,
                            ).copyWith(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () => setState(() => _qty++),
                            icon: const Icon(Icons.add_circle_outline),
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Unit",
                      style: AppDesign.bodySmall(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBody(context).withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceGrey,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Unit>(
                          value: _selectedUnit,
                          isExpanded: true,
                          items: widget.units
                              .map(
                                (u) => DropdownMenuItem(
                                  value: u,
                                  child: Text(u.name ?? ""),
                                ),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedUnit = val),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty && _selectedUnit != null) {
                  widget.onAdd(_nameController.text, _qty, _selectedUnit!);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                "Add to Pantry",
                style: AppDesign.bodyMedium(
                  context,
                ).copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IngredientItem extends StatelessWidget {
  final ItemsModel ingredient;
  final Function(int) onUpdate;

  const _IngredientItem({required this.ingredient, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ingredient.isAvailable
            ? AppColors.surfaceGreen.withOpacity(0.4)
            : AppColors.surfaceGrey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ingredient.isAvailable ? AppColors.accent : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(ingredient.icon, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.name ?? "Unknown Item",
                  style: AppDesign.bodyMedium(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHeading(context),
                  ),
                ),
                if (ingredient.isAvailable)
                  Text(
                    "${ingredient.quantity} ${ingredient.unit}",
                    style: AppDesign.bodySmall(context).copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else
                  Text(
                    "Out of stock",
                    style: AppDesign.bodySmall(context).copyWith(
                      color: AppColors.textBody(context).withOpacity(0.3),
                    ),
                  ),
              ],
            ),
          ),
          Row(
            children: [
              if (ingredient.isAvailable)
                IconButton(
                  onPressed: () => onUpdate((ingredient.quantity ?? 0) - 1),
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    size: 28,
                    color: AppColors.primary,
                  ),
                ),
              IconButton(
                onPressed: () => onUpdate((ingredient.quantity ?? 0) + 1),
                icon: Icon(
                  ingredient.isAvailable
                      ? Icons.add_circle
                      : Icons.add_circle_outline,
                  size: 28,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
