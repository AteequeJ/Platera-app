import '../../models/product_model.dart';
import '../api_client.dart';

class ProductService {
  final ApiClient _apiClient;

  ProductService(this._apiClient);

  Future<List<Product>> getProducts({String? search}) async {
    final response = await _apiClient.dio.get(
      'products',
      queryParameters: (search != null && search.isNotEmpty)
          ? {'search': search}
          : null,
    );
    return (response.data['data'] as List)
        .map((p) => Product.fromJson(p))
        .toList();
  }
}
