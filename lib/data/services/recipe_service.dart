import '../../models/recipe_model.dart';
import '../api_client.dart';

class RecipeService {
  final ApiClient _apiClient;

  RecipeService(this._apiClient);

  Future<AiSuggestionsResponse> getSuggestions({
    String? diet,
    String? cuisine,
    String? difficulty,
    int? maxTime,
    int? minCalories,
    int? maxCalories,
  }) async {
    final query = <String, dynamic>{
      if (diet != null) 'diet': diet,
      if (cuisine != null) 'cuisine': cuisine,
      if (difficulty != null) 'difficulty': difficulty,
      if (maxTime != null) 'maxTime': maxTime,
      if (minCalories != null) 'minCalories': minCalories,
      if (maxCalories != null) 'maxCalories': maxCalories,
    };
    final response = await _apiClient.dio.get(
      'recipes/ai-suggestions',
      queryParameters: query.isEmpty ? null : query,
    );
    return AiSuggestionsResponse.fromJson(response.data);
  }

  Future<SuggestionModel> getRecipeDetails(
    String recipeName, {
    int? servings,
    String? diet,
    String? cuisine,
    List<String>? exclude,
  }) async {
    final response = await _apiClient.dio.post(
      'recipes/get-recipe-details',
      data: {
        'recipeName': recipeName,
        if (servings != null) 'servings': servings,
        if (diet != null) 'diet': diet,
        if (cuisine != null) 'cuisine': cuisine,
        if (exclude != null) 'exclude': exclude,
      },
    );
    return SuggestionModel.fromJson(response.data);
  }
}
