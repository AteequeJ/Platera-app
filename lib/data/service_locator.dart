import 'api_client.dart';
import 'services/auth_service.dart';
import 'services/pantry_service.dart';
import 'services/recipe_service.dart';
import 'repositories/auth_repository.dart';
import 'repositories/pantry_repository.dart';
import 'repositories/recipe_repository.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  late final ApiClient apiClient;
  late final AuthRepository authRepository;
  late final PantryRepository pantryRepository;
  late final RecipeRepository recipeRepository;

  void setup() {
    apiClient = ApiClient();
    
    final authService = AuthService(apiClient);
    final pantryService = PantryService(apiClient);
    final recipeService = RecipeService(apiClient);
    
    authRepository = AuthRepository(authService);
    pantryRepository = PantryRepository(pantryService);
    recipeRepository = RecipeRepository(recipeService);
  }
}

final locator = ServiceLocator();
