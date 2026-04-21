import '../models/ingredient.dart';
import '../models/recipe_model.dart';

class MockData {
  // Making this a non-final list so we can add to it at runtime
  static List<ItemsModel> inventory = [
    ItemsModel(
      name: "Avocado",

      quantity: 2,

      id: 1,
      userId: 1,
      createdAt: DateTime.now(),
      categoryId: 1,
      unitId: 1,
      minQuantity: '1',
    ),
    ItemsModel(
      name: "Tomato",
      quantity: 4,
      id: 2,
      userId: 1,
      createdAt: DateTime.now(),
      categoryId: 1,
      unitId: 1,
      minQuantity: '1',
    ),
    ItemsModel(
      name: "Spinach",
      quantity: 1,
      id: 3,
      userId: 1,
      createdAt: DateTime.now(),
      categoryId: 1,
      unitId: 1,
      minQuantity: '1',
    ),
    ItemsModel(
      name: "Chickpeas",
      quantity: 0,
      id: 4,
      userId: 1,
      createdAt: DateTime.now(),
      categoryId: 1,
      unitId: 1,
      minQuantity: '1',
    ),
    ItemsModel(
      name: "Quinoa",
      quantity: 1,
      id: 5,
      userId: 1,
      createdAt: DateTime.now(),
      categoryId: 1,
      unitId: 1,
      minQuantity: '1',
    ),
    ItemsModel(
      name: "Lemon",
      quantity: 0,
      id: 6,
      userId: 1,
      createdAt: DateTime.now(),
      categoryId: 1,
      unitId: 1,
      minQuantity: '1',
    ),
    ItemsModel(
      name: "Salmon",
      quantity: 3,
      id: 7,
      userId: 1,
      createdAt: DateTime.now(),
      categoryId: 1,
      unitId: 1,
      minQuantity: '1',
    ),
    ItemsModel(
      name: "Blueberry",
      quantity: 0,
      id: 8,
      userId: 1,
      createdAt: DateTime.now(),
      categoryId: 1,
      unitId: 1,
      minQuantity: '1',
    ),
    ItemsModel(
      name: "Feta",
      quantity: 1,
      id: 9,
      userId: 1,
      createdAt: DateTime.now(),
      categoryId: 1,
      unitId: 1,
      minQuantity: '1',
    ),
    ItemsModel(
      name: "Ginger",
      quantity: 0,
      id: 10,
      userId: 1,
      createdAt: DateTime.now(),
      categoryId: 1,
      unitId: 1,
      minQuantity: '1',
    ),
    ItemsModel(
      name: "Beetroot",
      quantity: 2,
      id: 11,
      userId: 1,
      createdAt: DateTime.now(),
      categoryId: 1,
      unitId: 1,
      minQuantity: '1',
    ),
    ItemsModel(
      name: "Pasta",
      quantity: 0,
      id: 12,
      userId: 1,
      createdAt: DateTime.now(),
      categoryId: 1,
      unitId: 1,
      minQuantity: '1',
    ),
    ItemsModel(
      name: "Olive Oil",
      quantity: 5,
      id: 13,
      userId: 1,
      createdAt: DateTime.now(),
      categoryId: 1,
      unitId: 1,
      minQuantity: '1',
    ),
  ];

  static List<Recipe> recipes = [
    Recipe(
      name: "Beetroot Quinoa Salad",
      description: "A healthy and refreshing salad packed with nutrients.",
      imagePath: "assets/ready.png",
      cuisine: "Healthy",
      difficulty: "easy",
      servings: 2,
      preparationTime: 15,
      cookingTime: 15,
      totalTime: 30,
      caloriesPerServing: 220,

      ingredients: [
        RecipeIngredient(item: "Beetroot", quantity: "1", unit: "cup"),
        RecipeIngredient(item: "Quinoa", quantity: "1/2", unit: "cup"),
        RecipeIngredient(item: "Orange", quantity: "1", unit: "piece"),
        RecipeIngredient(item: "Ginger", quantity: "1", unit: "tsp"),
      ],

      steps: [
        RecipeStep(stepNumber: 1, instruction: "Cook quinoa", time: 15),
        RecipeStep(stepNumber: 2, instruction: "Chop beetroot and orange"),
        RecipeStep(stepNumber: 3, instruction: "Mix all ingredients"),
      ],

      tips: ["Use fresh ingredients for best taste"],
    ),

    Recipe(
      name: "Spinach & Feta Bowl",
      description: "A quick vegetarian bowl rich in iron and protein.",
      imagePath: "assets/almost.png",
      cuisine: "Vegetarian",
      difficulty: "easy",
      servings: 1,
      preparationTime: 10,
      cookingTime: 5,
      totalTime: 15,
      caloriesPerServing: 180,

      ingredients: [
        RecipeIngredient(item: "Spinach", quantity: "2", unit: "cup"),
        RecipeIngredient(item: "Feta", quantity: "1/2", unit: "cup"),
        RecipeIngredient(item: "Avocado", quantity: "1", unit: "piece"),
      ],

      steps: [
        RecipeStep(stepNumber: 1, instruction: "Wash and chop spinach"),
        RecipeStep(stepNumber: 2, instruction: "Slice avocado"),
        RecipeStep(stepNumber: 3, instruction: "Mix with feta and serve"),
      ],

      tips: ["Add olive oil for extra flavor"],
    ),

    Recipe(
      name: "Salmon Avocado Toast",
      description: "A delicious high-protein breakfast option.",
      imagePath: "assets/ready.png",
      cuisine: "Seafood",
      difficulty: "easy",
      servings: 1,
      preparationTime: 5,
      cookingTime: 5,
      totalTime: 10,
      caloriesPerServing: 300,

      ingredients: [
        RecipeIngredient(item: "Salmon", quantity: "100", unit: "g"),
        RecipeIngredient(item: "Avocado", quantity: "1", unit: "piece"),
        RecipeIngredient(item: "Lemon", quantity: "1", unit: "piece"),
      ],

      steps: [
        RecipeStep(stepNumber: 1, instruction: "Toast bread"),
        RecipeStep(stepNumber: 2, instruction: "Mash avocado"),
        RecipeStep(stepNumber: 3, instruction: "Top with salmon and lemon"),
      ],

      tips: ["Use sourdough bread for best taste"],
    ),

    Recipe(
      name: "Chickpea & Tomato Salad",
      description: "A simple and flavorful Indian-style salad.",
      imagePath: "assets/almost.png",
      cuisine: "Indian",
      difficulty: "easy",
      servings: 2,
      preparationTime: 10,
      cookingTime: 10,
      totalTime: 20,
      caloriesPerServing: 200,

      ingredients: [
        RecipeIngredient(item: "Chickpeas", quantity: "1/2", unit: "cup"),
        RecipeIngredient(item: "Tomato", quantity: "2", unit: "piece"),
        RecipeIngredient(item: "Spinach", quantity: "1", unit: "cup"),
        RecipeIngredient(item: "Olive Oil", quantity: "1", unit: "tbsp"),
      ],

      steps: [
        RecipeStep(stepNumber: 1, instruction: "Boil chickpeas", time: 10),
        RecipeStep(stepNumber: 2, instruction: "Chop vegetables"),
        RecipeStep(stepNumber: 3, instruction: "Mix and season"),
      ],

      tips: ["Add lemon juice for tangy flavor"],
    ),
  ];
  static List<ItemsModel> get availableIngredients =>
      inventory.where((i) => i.quantity! > 0).toList();

  static List<Recipe> get readyRecipes =>
      recipes.where((r) => r.getMissingCount(inventory) == 0).toList();

  static List<Recipe> get almostReadyRecipes => recipes.where((r) {
    int missing = r.getMissingCount(inventory);
    return missing > 0 && missing <= 2;
  }).toList();
}
