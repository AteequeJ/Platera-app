import '../../models/cart_model.dart';
import '../api_client.dart';

class CartService {
  final ApiClient _apiClient;

  CartService(this._apiClient);

  Future<CartData> getCart() async {
    final response = await _apiClient.dio.get('cart');
    return CartData.fromJson(response.data['data']);
  }

  Future<CartItem> addItem(int productId, int quantity) async {
    final response = await _apiClient.dio.post(
      'cart/items',
      data: {'productId': productId, 'quantity': quantity},
    );
    return CartItem.fromJson(response.data['data']);
  }

  Future<FromRecipeResult> addFromRecipe(
    String recipeName,
    List<String> missingIngredients,
  ) async {
    final response = await _apiClient.dio.post(
      'cart/items/from-recipe',
      data: {
        'recipeName': recipeName,
        'missingIngredients': missingIngredients,
      },
    );
    return FromRecipeResult.fromJson(response.data['data']);
  }

  Future<CartItem> updateItem(int cartItemId, int quantity) async {
    final response = await _apiClient.dio.patch(
      'cart/items/$cartItemId',
      data: {'quantity': quantity},
    );
    return CartItem.fromJson(response.data['data']);
  }

  Future<void> deleteItem(int cartItemId) async {
    await _apiClient.dio.delete('cart/items/$cartItemId');
  }
}
