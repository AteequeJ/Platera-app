import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/glass_card.dart';
import '../widgets/organic_background.dart';
import '../theme/app_design.dart';
import 'detail_screen.dart';

import '../data/service_locator.dart';
import '../models/recipe_model.dart';

class SuggestionsScreen extends StatefulWidget {
  const SuggestionsScreen({super.key});

  @override
  State<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  AiSuggestionsResponse? _suggestions;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final results = await locator.recipeRepository.getSuggestedRecipes();
      setState(() {
        _suggestions = results;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching suggestions: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final readyRecipes = _suggestions?.canMake ?? [];
    final almostReadyRecipes = _suggestions?.almostMake ?? [];

    return Scaffold(
      body: Stack(
        children: [
          const OrganicBackground(),
          
          SafeArea(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
              : ListView(
                  padding: EdgeInsets.all(AppDesign.padding),
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                          style: IconButton.styleFrom(
                            backgroundColor: isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.03),
                            padding: const EdgeInsets.all(12),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Suggestions",
                              style: AppDesign.headingLarge(context).copyWith(fontSize: 28),
                            ),
                            Text(
                              "Crafted from your digital pantry",
                              style: AppDesign.bodyMedium(context).copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    if (readyRecipes.isNotEmpty) ...[
                      const SizedBox(height: 32),
                      SectionHeader(title: "Ready to Cook", color: AppColors.accent),
                      const SizedBox(height: 16),
                      ...readyRecipes.map((r) => Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: DishCard(
                          name: r.name,
                          image: r.image,
                          isReady: true,
                          onTap: () => _openDetail(context, r),
                        ).animate().fadeIn(duration: 400.ms).moveY(begin: 20, end: 0),
                      )),
                    ],
                    
                    if (almostReadyRecipes.isNotEmpty) ...[
                      const SizedBox(height: 40),
                      SectionHeader(title: "Almost There", color: AppColors.accent.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      ...almostReadyRecipes.map((r) => Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: DishCard(
                          name: r.name,
                          image: r.image,
                          isReady: false,
                          missing: r.missing,
                          onTap: () => _openDetail(context, r),
                        ).animate().fadeIn(delay: 200.ms, duration: 400.ms).moveY(begin: 20, end: 0),
                      )),
                    ],

                    if (readyRecipes.isEmpty && almostReadyRecipes.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Center(child: Text("No suggestions found. Try adding more items to your pantry!")),
                      ),
                  ],
                ),
          ),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, SuggestionModel recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          name: recipe.name,
          image: recipe.image,
          missing: recipe.missing,
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final Color color;
  const SectionHeader({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: AppDesign.headingLarge(context).copyWith(fontSize: 18, letterSpacing: 0.5),
        ),
      ],
    );
  }
}

class DishCard extends StatelessWidget {
  final String name;
  final String image;
  final bool isReady;
  final List<String>? missing;
  final VoidCallback onTap;

  const DishCard({
    super.key,
    required this.name,
    required this.image,
    required this.isReady,
    required this.onTap,
    this.missing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      child: image.startsWith('http') 
                        ? Image.network(image, fit: BoxFit.cover)
                        : Image.asset(image, fit: BoxFit.cover),
                    ),
                  ),
                  if (isReady)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: (isDark ? AppColors.background(context) : Colors.white).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle, color: AppColors.accent, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              "READY",
                              style: AppDesign.bodyMedium(context).copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppDesign.headingLarge(context).copyWith(fontSize: 20),
                  ),
                  if (!isReady && missing != null) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: missing!.map((m) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.02),
                          border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03)),
                        ),
                        child: Text(
                          "+ $m",
                          style: AppDesign.bodyMedium(context).copyWith(
                            fontSize: 11,
                            color: AppColors.textBody(context).withOpacity(0.4),
                          ),
                        ),
                      )).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
