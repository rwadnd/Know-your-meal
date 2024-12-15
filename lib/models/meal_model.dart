class Meal {
  final String name;
  final String description;
  final String imageUrl;
  final int timeToCook;
  final int calories;
  final List<String> ingredients;
  final List<String> filters;
  final List<String> preparation; // Add this field

  Meal({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.timeToCook,
    required this.calories,
    required this.ingredients,
    required this.filters,
    required this.preparation, // Initialize this field
  });

  factory Meal.fromMap(String id, Map<String, dynamic> data) {
    return Meal(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      timeToCook: data['timeToCook'] ?? 0,
      calories: data['calories'] ?? 0,
      ingredients: List<String>.from(data['ingredients'] ?? []),
      filters: List<String>.from(data['filters'] ?? []),
      preparation: List<String>.from(data['preparation'] ?? []), // Parse this
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'timeToCook': timeToCook,
      'calories': calories,
      'ingredients': ingredients,
      'filters': filters,
      'preparation': preparation, // Include this field
    };
  }
}
