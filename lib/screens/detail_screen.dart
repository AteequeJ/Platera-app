import 'package:flutter/material.dart';
import '../theme/app_design.dart';
import '../widgets/recipe_widgets.dart';
import '../models/recipe_model.dart';
import '../data/service_locator.dart';

class DetailScreen extends StatefulWidget {
  final String name;
  final String image;

  const DetailScreen({super.key, required this.name, required this.image});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  SuggestionModel? _details;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await locator.recipeRepository.getRecipeDetails(widget.name);
      setState(() {
        _details = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          "Recipe",
          style: AppDesign.bodyMedium(
            context,
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(
                Icons.favorite_border_rounded,
                color: AppColors.primary,
              ),
              onPressed: () {},
              style: IconButton.styleFrom(
                backgroundColor: AppColors.surfaceGrey,
                shape: const CircleBorder(),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            )
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: $_error", textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchDetails,
                    child: const Text("Retry"),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(AppDesign.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const SizedBox(height: 16),
                      Text(
                        widget.name,
                        style: AppDesign.headingLarge(
                          context,
                        ).copyWith(fontSize: 28),
                      ),
                      if (_details?.description != null &&
                          _details!.description.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          _details!.description,
                          style: AppDesign.bodyMedium(
                            context,
                          ).copyWith(color: Colors.grey[600], height: 1.4),
                        ),
                      ],
                      if (_details?.cuisine != null &&
                              _details!.cuisine.isNotEmpty ||
                          _details?.difficulty != null &&
                              _details!.difficulty.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            if (_details?.cuisine.isNotEmpty ?? false)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceGreen.withOpacity(
                                    0.3,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  _details!.cuisine,
                                  style: AppDesign.bodyMedium(context).copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            if (_details?.cuisine.isNotEmpty ?? false)
                              const SizedBox(width: 8),
                            if (_details?.difficulty.isNotEmpty ?? false)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceGrey,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  _details!.difficulty.toUpperCase(),
                                  style: AppDesign.bodyMedium(context).copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 24),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppDesign.borderRadiusLarge,
                        ),
                        child: widget.image.startsWith('http')
                            ? Image.network(
                                widget.image,
                                width: double.infinity,
                                height: 250,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                widget.image,
                                width: double.infinity,
                                height: 250,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(height: 32),
                      // Stats Row
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceGrey,
                          borderRadius: BorderRadius.circular(
                            AppDesign.borderRadiusMedium,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            StatTile(
                              title: "Servings",
                              value: "${_details?.servings ?? 1}",
                            ),
                            StatTile(
                              title: "Time",
                              value:
                                  "${(_details?.totalTime ?? 0) > 0 ? _details!.totalTime : ((_details?.preparationTime ?? 0) + (_details?.cookingTime ?? 0))} m",
                            ),
                            StatTile(
                              title: "Calories",
                              value:
                                  "${_details?.caloriesPerServing ?? 0} kcal",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Ingredients Accordion
                      if (_details?.ingredients.isNotEmpty ?? false)
                        AccordionSection(
                          title: "Ingredients",
                          backgroundColor: AppColors.surfaceGreen.withOpacity(
                            0.3,
                          ),
                          children: _details!.ingredients
                              .map((ing) => _IngredientRow(ingredient: ing))
                              .toList(),
                        ),
                      // Direction Accordion
                      if (_details?.steps.isNotEmpty ?? false)
                        AccordionSection(
                          title: "Directions",
                          backgroundColor: AppColors.surfaceGreen,
                          children: _details!.steps.asMap().entries.map((
                            entry,
                          ) {
                            int idx = entry.key + 1;
                            String step = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "$idx. ",
                                    style: AppDesign.bodyMedium(context)
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      step,
                                      style: AppDesign.bodyMedium(
                                        context,
                                      ).copyWith(fontSize: 15, height: 1.6),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      // Tips Accordion
                      if (_details?.tips.isNotEmpty ?? false)
                        AccordionSection(
                          title: "Chef's Tips",
                          backgroundColor: AppColors.surfaceGrey.withOpacity(
                            0.5,
                          ),
                          children: _details!.tips.map((tip) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 4),
                                    child: Icon(
                                      Icons.lightbulb_outline,
                                      size: 18,
                                      color: AppColors.accent,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      tip,
                                      style: AppDesign.bodyMedium(context)
                                          .copyWith(
                                            height: 1.5,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey[700],
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 100), // Space for floating button
                    ],
                  ),
                ),
                Positioned(
                  bottom: 32,
                  left: AppDesign.padding,
                  right: AppDesign.padding,
                  child: _StartCookingButton(),
                ),
              ],
            ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  final RecipeIngredient ingredient;

  const _IngredientRow({required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: AppColors.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              ingredient.displayString,
              style: AppDesign.bodyMedium(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _StartCookingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(100),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Center(
              child: Text(
                "Start cooking",
                style: AppDesign.bodyMedium(
                  context,
                ).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
