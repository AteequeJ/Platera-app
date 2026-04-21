import '../../models/ingredient.dart';
import '../../models/pantry_models.dart';
import '../services/pantry_service.dart';

class PantryRepository {
  final PantryService _pantryService;

  PantryRepository(this._pantryService);

  Future<List<ItemsModel>> getInventory() async {
    return await _pantryService.getItems();
  }

  Future<ItemsModel> addIngredient(ItemsModel ingredient) async {
    return await _pantryService.addItem(ingredient);
  }

  Future<void> updateStock(int itemId, double amount, bool isAddition) async {
    final type = isAddition ? 'add' : 'subtract'; // Adjusted logic for clarity
    await _pantryService.updateStock(itemId, amount, type);
  }

  Future<List<Category>> getCategories() async {
    return await _pantryService.getCategories();
  }

  Future<List<Unit>> getUnits() async {
    return await _pantryService.getUnits();
  }

  Future<List<StockHistory>> getHistory(int itemId) async {
    return await _pantryService.getStockHistory(itemId);
  }
}
