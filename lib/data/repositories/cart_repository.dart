import '../../models/cart_model.dart';
import '../services/cart_service.dart';

class CartRepository {
  final CartService _cartService;

  CartRepository(this._cartService);

  Future<CartData> getCart() async {
    return await _cartService.getCart();
  }

  Future<CartItem> addItem(int productId, int quantity) async {
    return await _cartService.addItem(productId, quantity);
  }

  Future<FromRecipeResult> addFromRecipe(
    String recipeName,
    List<String> missingIngredients,
  ) async {
    return await _cartService.addFromRecipe(recipeName, missingIngredients);
  }

  Future<CartItem> updateItem(int cartItemId, int quantity) async {
    return await _cartService.updateItem(cartItemId, quantity);
  }

  Future<void> deleteItem(int cartItemId) async {
    await _cartService.deleteItem(cartItemId);
  }
}
