import '../../models/ingredient.dart';
import '../../models/pantry_models.dart';
import '../api_client.dart';

class PantryService {
  final ApiClient _apiClient;

  PantryService(this._apiClient);

  // Categories
  Future<List<Category>> getCategories() async {
    final response = await _apiClient.dio.get('items/Categories');
    return (response.data['data'] as List)
        .map((c) => Category.fromJson(c))
        .toList();
  }

  Future<Category> addCategory(String name) async {
    final response = await _apiClient.dio.post(
      'items/Categories',
      data: {'name': name},
    );
    return Category.fromJson(response.data);
  }

  Future<void> deleteCategory(int id) async {
    await _apiClient.dio.delete('items/Categories/$id');
  }

  // Units
  Future<List<Unit>> getUnits() async {
    final response = await _apiClient.dio.get('items/units');
    return (response.data['data'] as List)
        .map((u) => Unit.fromJson(u))
        .toList();
  }

  // Items
  Future<List<ItemsModel>> getItems() async {
    final response = await _apiClient.dio.get('items/item');
    return (response.data['data'] as List)
        .map((i) => ItemsModel.fromJson(i))
        .toList();
  }

  Future<ItemsModel> addItem(ItemsModel item) async {
    final response = await _apiClient.dio.post(
      'items/item',
      data: item.toJson(),
    );
    return ItemsModel.fromJson(response.data['data']);
  }

  Future<void> updateStock(int itemId, double amount, String type) async {
    await _apiClient.dio.patch(
      'items/items/$itemId/stock',
      data: {'amount': amount, 'type': type},
    );
  }

  Future<List<StockHistory>> getStockHistory(int itemId) async {
    final response = await _apiClient.dio.get('items/items/$itemId/history');
    return (response.data as List)
        .map((h) => StockHistory.fromJson(h))
        .toList();
  }
}
