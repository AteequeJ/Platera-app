import '../../models/recipe_model.dart';
import '../services/recipe_service.dart';

class RecipeRepository {
  final RecipeService _recipeService;

  RecipeRepository(this._recipeService);

  Future<AiSuggestionsResponse> getSuggestedRecipes() async {
    return await _recipeService.getSuggestions();
  }

  Future<SuggestionModel> getRecipeDetails(String name) async {
    return await _recipeService.getRecipeDetails(name);
  }
}
