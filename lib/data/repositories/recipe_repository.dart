import '../../models/recipe_model.dart';
import '../services/recipe_service.dart';

class RecipeRepository {
  final RecipeService _recipeService;

  RecipeRepository(this._recipeService);

  Future<AiSuggestionsResponse> getSuggestedRecipes({
    String? diet,
    String? cuisine,
    String? difficulty,
    int? maxTime,
    int? minCalories,
    int? maxCalories,
  }) async {
    return await _recipeService.getSuggestions(
      diet: diet,
      cuisine: cuisine,
      difficulty: difficulty,
      maxTime: maxTime,
      minCalories: minCalories,
      maxCalories: maxCalories,
    );
  }

  Future<SuggestionModel> getRecipeDetails(
    String name, {
    int? servings,
    String? diet,
    String? cuisine,
    List<String>? exclude,
  }) async {
    return await _recipeService.getRecipeDetails(
      name,
      servings: servings,
      diet: diet,
      cuisine: cuisine,
      exclude: exclude,
    );
  }
}
