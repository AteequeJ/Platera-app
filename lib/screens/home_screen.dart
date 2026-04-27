import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../theme/app_design.dart';
import '../widgets/recipe_widgets.dart';
import '../models/recipe_model.dart';
import '../data/service_locator.dart';
import 'detail_screen.dart';
import 'inventory_screen.dart';
import 'signin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        String errorMessage = e.toString();
        if (e is DioException) {
          errorMessage =
              e.response?.data?['message'] ?? e.message ?? e.toString();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error fetching suggestions: $errorMessage"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await locator.authRepository.logout();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SigninScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final readyRecipes = _suggestions?.canMake ?? [];
    final almostReadyRecipes = _suggestions?.almostMake ?? [];

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              )
            : RefreshIndicator(
                onRefresh: _fetchData,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: AppDesign.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: _handleLogout,
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: AppColors.surfaceGrey,
                                  child: Icon(
                                    CupertinoIcons.person,
                                    color: AppColors.textBody(context),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hello Chef!",
                                    style: AppDesign.bodySmall(context).copyWith(
                                      color: AppColors.textBody(context)
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                  Text(
                                    "Welcome back",
                                    style: AppDesign.bodyMedium(context).copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const InventoryScreen(),
                                ),
                              );
                              _fetchData(); // Refresh data after returning
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                CupertinoIcons.bag,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Search Bar
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceGrey,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: AppColors.textBody(
                                context,
                              ).withOpacity(0.4),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Search recipes",
                              style: AppDesign.bodyMedium(context).copyWith(
                                color: AppColors.textBody(
                                  context,
                                ).withOpacity(0.5),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),

                      // SECTION 2: READY TO COOK
                      if (readyRecipes.isNotEmpty) ...[
                        _SectionHeader(title: "Ready to Cook"),
                        const SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: readyRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = readyRecipes[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: RecipeCard(
                                title: recipe.name,
                                imagePath: recipe.image,
                                time: "Ready",
                                cuisine: "Suggested",
                                width: double.infinity,
                                missingCount: 0,
                                onTap: () => _openDetail(context, recipe),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                      ],

                      // SECTION 3: ALMOST THERE
                      if (almostReadyRecipes.isNotEmpty) ...[
                        _SectionHeader(title: "Almost There"),
                        const SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: almostReadyRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = almostReadyRecipes[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: RecipeCard(
                                title: recipe.name,
                                imagePath: recipe.image,
                                time: "Almost",
                                cuisine: "Suggested",
                                width: double.infinity,
                                missingCount: recipe.missing.length,
                                missingNames: recipe.missing,
                                onTap: () => _openDetail(context, recipe),
                              ),
                            );
                          },
                        ),
                      ],

                      if (readyRecipes.isEmpty && almostReadyRecipes.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: Center(
                            child: Text(
                              "No suggestions found. Try adding more items to your pantry!",
                            ),
                          ),
                        ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void _openDetail(BuildContext context, SuggestionModel recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DetailScreen(name: recipe.name, image: recipe.image),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppDesign.headingMedium(context).copyWith(fontSize: 22),
        ),
      ],
    );
  }
}
