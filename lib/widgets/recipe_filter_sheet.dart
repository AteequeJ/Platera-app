import 'package:flutter/material.dart';
import '../theme/app_design.dart';
import '../models/recipe_model.dart';
import 'recipe_widgets.dart';

const List<MapEntry<String, String?>> _dietOptions = [
  MapEntry("Any", null),
  MapEntry("Veg", "veg"),
  MapEntry("Non-veg", "non_veg"),
  MapEntry("Vegan", "vegan"),
];

const List<MapEntry<String, String?>> _difficultyOptions = [
  MapEntry("Any", null),
  MapEntry("Easy", "easy"),
  MapEntry("Medium", "medium"),
  MapEntry("Hard", "hard"),
];

class RecipeFilterSheet extends StatefulWidget {
  final RecipeFilters initial;

  const RecipeFilterSheet({super.key, required this.initial});

  @override
  State<RecipeFilterSheet> createState() => _RecipeFilterSheetState();
}

class _RecipeFilterSheetState extends State<RecipeFilterSheet> {
  String? _diet;
  String? _difficulty;
  late final TextEditingController _cuisineController;
  late final TextEditingController _maxTimeController;
  late final TextEditingController _minCaloriesController;
  late final TextEditingController _maxCaloriesController;

  @override
  void initState() {
    super.initState();
    _diet = widget.initial.diet;
    _difficulty = widget.initial.difficulty;
    _cuisineController = TextEditingController(text: widget.initial.cuisine ?? '');
    _maxTimeController = TextEditingController(text: widget.initial.maxTime?.toString() ?? '');
    _minCaloriesController = TextEditingController(text: widget.initial.minCalories?.toString() ?? '');
    _maxCaloriesController = TextEditingController(text: widget.initial.maxCalories?.toString() ?? '');
  }

  @override
  void dispose() {
    _cuisineController.dispose();
    _maxTimeController.dispose();
    _minCaloriesController.dispose();
    _maxCaloriesController.dispose();
    super.dispose();
  }

  void _apply() {
    final cuisine = _cuisineController.text.trim();
    Navigator.pop(
      context,
      RecipeFilters(
        diet: _diet,
        difficulty: _difficulty,
        cuisine: cuisine.isEmpty ? null : cuisine,
        maxTime: int.tryParse(_maxTimeController.text.trim()),
        minCalories: int.tryParse(_minCaloriesController.text.trim()),
        maxCalories: int.tryParse(_maxCaloriesController.text.trim()),
      ),
    );
  }

  void _clear() {
    Navigator.pop(context, const RecipeFilters());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDesign.padding,
        right: AppDesign.padding,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.surfaceGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text("Filter Recipes", style: AppDesign.headingMedium(context).copyWith(fontSize: 22)),
            const SizedBox(height: 24),

            Text("Diet", style: AppDesign.bodySmall(context).copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _dietOptions
                  .map((opt) => CategoryChip(
                        label: opt.key,
                        isActive: _diet == opt.value,
                        onTap: () => setState(() => _diet = opt.value),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),

            Text("Difficulty", style: AppDesign.bodySmall(context).copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _difficultyOptions
                  .map((opt) => CategoryChip(
                        label: opt.key,
                        isActive: _difficulty == opt.value,
                        onTap: () => setState(() => _difficulty = opt.value),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),

            Text("Cuisine", style: AppDesign.bodySmall(context).copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _FilterField(controller: _cuisineController, hint: "e.g. Italian"),
            const SizedBox(height: 24),

            Text("Max Time (min)", style: AppDesign.bodySmall(context).copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _FilterField(controller: _maxTimeController, hint: "e.g. 30", isNumber: true),
            const SizedBox(height: 24),

            Text("Calories", style: AppDesign.bodySmall(context).copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _FilterField(controller: _minCaloriesController, hint: "Min", isNumber: true)),
                const SizedBox(width: 12),
                Expanded(child: _FilterField(controller: _maxCaloriesController, hint: "Max", isNumber: true)),
              ],
            ),
            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clear,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      side: BorderSide(color: AppColors.surfaceGrey, width: 2),
                    ),
                    child: Text("Clear", style: AppDesign.bodyMedium(context).copyWith(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _apply,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                    ),
                    child: const Text(
                      "Apply",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isNumber;

  const _FilterField({required this.controller, required this.hint, this.isNumber = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceGrey,
        borderRadius: BorderRadius.circular(AppDesign.borderRadiusMedium),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppDesign.bodyMedium(context).copyWith(color: AppColors.textBody(context).withOpacity(0.3)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }
}
