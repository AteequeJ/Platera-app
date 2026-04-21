import '../../models/recipe_model.dart';
import '../api_client.dart';

class RecipeService {
  final ApiClient _apiClient;

  RecipeService(this._apiClient);

  Future<AiSuggestionsResponse> getSuggestions() async {
    final response = await _apiClient.dio.get('recipes/ai-suggestions');
    return AiSuggestionsResponse.fromJson(response.data);
  }

  Future<SuggestionModel> getRecipeDetails(String recipeName) async {
    final response = await _apiClient.dio.post(
      'recipes/get-recipe-details',
      data: {'recipeName': recipeName},
    );
    return SuggestionModel.fromJson(response.data);
  }
}
