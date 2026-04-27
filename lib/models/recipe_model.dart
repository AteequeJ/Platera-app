import 'dart:convert';
import 'ingredient.dart';

class RecipeIngredient {
  final String item;
  final String quantity; // stored as string to preserve fractions like "1/2"
  final String unit;

  RecipeIngredient({
    required this.item,
    required this.quantity,
    required this.unit,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      item: json['item'] ?? '',
      quantity: json['quantity']?.toString() ?? '',
      unit: json['unit'] ?? '',
    );
  }

  String get displayString {
    final q = quantity.isNotEmpty ? quantity : '';
    if (unit.isNotEmpty) {
      return "$q $unit $item".trim();
    }
    return "$q $item".trim();
  }
}

class RecipeStep {
  final int stepNumber;
  final String instruction;
  final int? time;

  RecipeStep({required this.stepNumber, required this.instruction, this.time});

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      stepNumber: json['step_number'] ?? 0,
      instruction: json['instruction'] ?? '',
      time: json['time'],
    );
  }
}

class Recipe {
  final String name;
  final String description;
  final int servings;
  final int preparationTime;
  final int cookingTime;
  final int totalTime;
  final String difficulty;
  final String cuisine;
  final int caloriesPerServing;

  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;
  final List<String> tips;

  // Optional UI helpers
  final String imagePath;

  Recipe({
    required this.name,
    required this.description,
    required this.servings,
    required this.preparationTime,
    required this.cookingTime,
    required this.totalTime,
    required this.difficulty,
    required this.cuisine,
    required this.caloriesPerServing,
    required this.ingredients,
    required this.steps,
    required this.tips,
    this.imagePath = 'assets/ready.png',
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      servings: json['servings'] ?? 1,
      preparationTime: json['preparation_time'] ?? 0,
      cookingTime: json['cooking_time'] ?? 0,
      totalTime:
          json['total_time'] ??
          ((json['preparation_time'] ?? 0) + (json['cooking_time'] ?? 0)),
      difficulty: json['difficulty'] ?? 'medium',
      cuisine: json['cuisine'] ?? 'Fusion',
      caloriesPerServing: json['calories_per_serving'] ?? 0,

      ingredients: (json['ingredients'] as List? ?? [])
          .map((e) => RecipeIngredient.fromJson(e))
          .toList(),

      steps: (json['steps'] as List? ?? [])
          .map((e) => RecipeStep.fromJson(e))
          .toList(),

      tips: List<String>.from(json['tips'] ?? []),
    );
  }

  // 🔹 UI Helpers

  String get timeString => "$totalTime mins";

  String get caloriesString => "$caloriesPerServing kcal";

  List<String> get ingredientNames => ingredients.map((e) => e.item).toList();

  // 🔹 Inventory Logic (Updated)

  int getMissingCount(List<ItemsModel> inventory) {
    int count = 0;

    for (var ingredient in ingredients) {
      bool found = inventory.any(
        (inv) =>
            inv.name?.toLowerCase() == ingredient.item.toLowerCase() &&
            (inv.quantity ?? 0) > 0,
      );

      if (!found) count++;
    }

    return count;
  }

  List<String> getMissingNames(List<ItemsModel> inventory) {
    List<String> missing = [];

    for (var ingredient in ingredients) {
      bool found = inventory.any(
        (inv) =>
            inv.name?.toLowerCase() == ingredient.item.toLowerCase() &&
            (inv.quantity ?? 0) > 0,
      );

      if (!found) missing.add(ingredient.item);
    }

    return missing;
  }
}

class SuggestionModel {
  final String name;
  final String image;
  final List<String> missing;
  final List<RecipeStep> steps;
  final List<RecipeIngredient> ingredients;
  final int servings;
  final int preparationTime;
  final int cookingTime;
  final int totalTime;
  final String difficulty;
  final String cuisine;
  final int caloriesPerServing;
  final String description;
  final List<String> tips;

  SuggestionModel({
    required this.name,
    required this.image,
    this.missing = const [],
    this.steps = const [],
    this.ingredients = const [],
    this.servings = 1,
    this.preparationTime = 0,
    this.cookingTime = 0,
    this.totalTime = 0,
    this.difficulty = 'medium',
    this.cuisine = '',
    this.caloriesPerServing = 0,
    this.description = '',
    this.tips = const [],
  });

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    // Check if data is wrapped in a 'data' key (for detail response)
    // or if it's the raw suggestion object
    final data = json.containsKey('data') ? json['data'] : json;

    return SuggestionModel(
      name: data['name'] ?? '',
      image: data['image'] ?? 'assets/ready.png',
      missing: data['missing'] != null ? List<String>.from(data['missing']) : [],
      steps: _parseSteps(data['steps']),
      ingredients: _parseIngredients(data['ingredients']),
      servings: data['servings'] ?? 1,
      preparationTime: data['preparation_time'] ?? 0,
      cookingTime: data['cooking_time'] ?? 0,
      totalTime: data['total_time'] ?? 0,
      difficulty: data['difficulty'] ?? 'medium',
      cuisine: data['cuisine'] ?? '',
      caloriesPerServing: data['calories_per_serving'] ?? 0,
      description: data['description'] ?? '',
      tips: data['tips'] != null ? List<String>.from(data['tips']) : [],
    );
  }

  static List<RecipeStep> _parseSteps(dynamic json) {
    if (json == null) return [];
    if (json is List) {
      return json.asMap().entries.map((entry) {
        final idx = entry.key;
        final item = entry.value;
        if (item is Map<String, dynamic>) {
          return RecipeStep.fromJson(item);
        }
        return RecipeStep(stepNumber: idx + 1, instruction: item.toString());
      }).toList();
    }
    return [];
  }

  static List<RecipeIngredient> _parseIngredients(dynamic json) {
    if (json == null) return [];
    if (json is List) {
      return json.map((item) {
        if (item is Map<String, dynamic>) {
          return RecipeIngredient.fromJson(item);
        }
        return RecipeIngredient(item: item.toString(), quantity: '1', unit: '');
      }).toList();
    }
    return [];
  }
}

class AiSuggestionsResponse {
  final List<SuggestionModel> canMake;
  final List<SuggestionModel> almostMake;

  AiSuggestionsResponse({required this.canMake, required this.almostMake});

  factory AiSuggestionsResponse.fromJson(Map<String, dynamic> json) {
    // Some backend configurations might return the data object directly
    // or wrap it in a 'data' key. This handles both.
    final data = json.containsKey('data')
        ? (json['data'] as Map<String, dynamic>? ?? {})
        : json;

    Map<String, dynamic> sourceData = data;

    // Detect and parse stringified 'raw' field if present
    if (data.containsKey('raw') && data['raw'] is String) {
      final rawString = data['raw'] as String;
      try {
        sourceData = jsonDecode(rawString);
      } catch (e) {
        print('Error parsing raw AI response using standard JSON decoder: $e');
        print('Attempting to salvage truncated data...');
        sourceData = _salvageTruncatedJson(rawString);
      }
    }

    return AiSuggestionsResponse(
      canMake: (sourceData['can_make'] as List? ?? []).map((item) {
        if (item is String) {
          return SuggestionModel(name: item, image: 'assets/ready.png');
        }
        return SuggestionModel.fromJson(item as Map<String, dynamic>);
      }).toList(),
      almostMake: (sourceData['almost_make'] as List? ?? [])
          .map((item) => SuggestionModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Extracts valid recipe data from a potentially truncated or malformed JSON string.
  static Map<String, dynamic> _salvageTruncatedJson(String raw) {
    // Sets to prevent duplicates if the AI is looping/repeating
    final canMake = <String>{};
    final almostMake = <Map<String, dynamic>>[];
    final seenAlmost = <String>{};

    // 1. Extract can_make section recipes (list of strings)
    final canMakeMatch = RegExp(
      r'"can_make"\s*:\s*\[(.*?)(?:\]|$)',
      dotAll: true,
    ).firstMatch(raw);
    if (canMakeMatch != null) {
      final content = canMakeMatch.group(1) ?? '';
      final nameMatches = RegExp(r'"([^"]+)"').allMatches(content);
      for (final m in nameMatches) {
        final name = m.group(1);
        if (name != null && name != 'can_make' && name != 'almost_make') {
          canMake.add(name);
        }
      }
    }

    // 2. Extract almost_make section items (list of objects)
    // Matches patterns like {"name": "...", "missing": ["...", "..."]}
    final almostMatches = RegExp(
      r'\{\s*"name"\s*:\s*"([^"]+)"(?:,\s*"missing"\s*:\s*\[(.*?)(?:\]|$))?',
      dotAll: true,
    ).allMatches(raw);

    for (final m in almostMatches) {
      final name = m.group(1);
      // Skip field names and duplicates
      if (name != null &&
          name != 'name' &&
          name != 'missing' &&
          !seenAlmost.contains(name)) {
        final missing = <String>[];
        final missingContent = m.group(2) ?? '';
        final missingMatches = RegExp(r'"([^"]+)"').allMatches(missingContent);
        for (final mm in missingMatches) {
          final mName = mm.group(1);
          if (mName != null) missing.add(mName);
        }

        almostMake.add({'name': name, 'missing': missing});
        seenAlmost.add(name);
      }
    }

    return {'can_make': canMake.toList(), 'almost_make': almostMake};
  }
}
