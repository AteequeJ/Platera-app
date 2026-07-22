import 'api_client.dart';
import 'services/auth_service.dart';
import 'services/pantry_service.dart';
import 'services/recipe_service.dart';
import 'services/product_service.dart';
import 'services/cart_service.dart';
import 'services/order_service.dart';
import 'repositories/auth_repository.dart';
import 'repositories/pantry_repository.dart';
import 'repositories/recipe_repository.dart';
import 'repositories/product_repository.dart';
import 'repositories/cart_repository.dart';
import 'repositories/order_repository.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  late final ApiClient apiClient;
  late final AuthRepository authRepository;
  late final PantryRepository pantryRepository;
  late final RecipeRepository recipeRepository;
  late final ProductRepository productRepository;
  late final CartRepository cartRepository;
  late final OrderRepository orderRepository;

  void setup() {
    apiClient = ApiClient();

    final authService = AuthService(apiClient);
    final pantryService = PantryService(apiClient);
    final recipeService = RecipeService(apiClient);
    final productService = ProductService(apiClient);
    final cartService = CartService(apiClient);
    final orderService = OrderService(apiClient);

    authRepository = AuthRepository(authService);
    pantryRepository = PantryRepository(pantryService);
    recipeRepository = RecipeRepository(recipeService);
    productRepository = ProductRepository(productService);
    cartRepository = CartRepository(cartService);
    orderRepository = OrderRepository(orderService);
  }
}

final locator = ServiceLocator();
