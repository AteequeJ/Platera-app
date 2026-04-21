import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_design.dart';

class Ingredient {
  final String name;
  final String icon;
  final double size;

  Ingredient(this.name, this.icon, this.size);
}

class IngredientCloud extends StatelessWidget {
  final List<Ingredient> ingredients = [
    Ingredient('Avocado', '🥑', 1.2),
    Ingredient('Tomato', '🍅', 0.9),
    Ingredient('Spinach', '🍃', 1.1),
    Ingredient('Chickpeas', '🫘', 0.8),
    Ingredient('Quinoa', '🌾', 1.0),
    Ingredient('Lemon', '🍋', 0.7),
    Ingredient('Salmon', '🐟', 1.3),
  ];

  IngredientCloud({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: ingredients.map((ing) {
            final random = Random();
            final top = random.nextDouble() * (constraints.maxHeight - 60);
            final left = random.nextDouble() * (constraints.maxWidth - 120);

            return Positioned(
              top: top,
              left: left,
              child: _OrganicIngredientChip(ingredient: ing),
            );
          }).toList(),
        );
      },
    );
  }
}

class _OrganicIngredientChip extends StatelessWidget {
  final Ingredient ingredient;

  const _OrganicIngredientChip({required this.ingredient});

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.02) : Colors.black.withOpacity(0.01),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(ingredient.icon, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text(
                ingredient.name,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: AppColors.textHeading(context).withOpacity(0.7),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(
          begin: -15,
          end: 15,
          duration: (3000 + random.nextInt(2000)).milliseconds,
          curve: Curves.easeInOutSine,
        )
        .moveX(
          begin: -5,
          end: 5,
          duration: (4000 + random.nextInt(2000)).milliseconds,
          curve: Curves.easeInOutSine,
        );
  }
}
