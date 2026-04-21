import 'package:flutter/material.dart';
import '../theme/app_design.dart';
import '../widgets/recipe_widgets.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

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
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surfaceGrey,
              shape: const CircleBorder(),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Favorite Recipe",
          style: AppDesign.bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppDesign.padding),
        children: [
          _CategorySection(
            title: "Salad",
            count: 2,
            isExpanded: true,
            recipes: [
              RecipeCard(
                title: "Vegan Mix Vegetable Caesar Salad",
                imagePath: "assets/ready.png",
                time: "20 mins",
                cuisine: "Healthy",
                views: "140k views",
                height: 280,
                width: 220,
              ),
              RecipeCard(
                title: "Spinach & Blueberry Feta Salad",
                imagePath: "assets/almost.png",
                time: "15 mins",
                cuisine: "Vegetarian",
                views: "120k views",
                height: 280,
                width: 220,
              ),
            ],
          ),
          _CategoryHeader(title: "Dessert", count: 10),
          _CategoryHeader(title: "Main Course", count: 4),
          _CategoryHeader(title: "Breakfast", count: 2),
          _CategoryHeader(title: "Soup", count: 5),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final String title;
  final int count;
  final List<Widget> recipes;
  final bool isExpanded;

  const _CategorySection({
    required this.title,
    required this.count,
    required this.recipes,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: AppDesign.headingMedium(context).copyWith(fontSize: 22),
                ),
                const SizedBox(width: 8),
                Text(
                  "$count",
                  style: AppDesign.bodyMedium(context).copyWith(
                    color: AppColors.textBody(context).withOpacity(0.4),
                  ),
                ),
              ],
            ),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: AppColors.textHeading(context),
            ),
          ],
        ),
        if (isExpanded) ...[
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: recipes.map((r) => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: r,
              )).toList(),
            ),
          ),
        ],
        const SizedBox(height: 32),
      ],
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  final String title;
  final int count;

  const _CategoryHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: AppDesign.headingMedium(context).copyWith(fontSize: 22),
                ),
                const SizedBox(width: 8),
                Text(
                  "$count",
                  style: AppDesign.bodyMedium(context).copyWith(
                    color: AppColors.textBody(context).withOpacity(0.4),
                  ),
                ),
              ],
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textHeading(context),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
