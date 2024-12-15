import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/meal_model.dart';
import '../widgets/meal_card.dart';
import '../widgets/ingredients_popup.dart';
import '../widgets/filter_popup.dart';

class HomeContentScreen extends StatefulWidget {
  @override
  _HomeContentScreenState createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  List<Meal> meals = []; // Meals fetched from Firebase
  List<Meal> filteredMeals = []; // Meals after applying filters
  bool isLoading = true;
  bool isGeneralFilterApplied = false; // Track general filter state
  bool isIngredientsFiltered = false; // Track ingredient filter state

  @override
  void initState() {
    super.initState();
    _fetchMeals();
  }

  Future<void> _fetchMeals() async {
    try {
      final snapshot = await _database.child('meals').get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        final fetchedMeals = data.entries.map((entry) {
          return Meal.fromMap(entry.key, Map<String, dynamic>.from(entry.value));
        }).toList();

        setState(() {
          meals = fetchedMeals;
          filteredMeals = fetchedMeals;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching meals: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterMealsByGeneral(List<String> filters) {
    setState(() {
      filteredMeals = meals.where((meal) {
        return filters.every((filter) => meal.filters.contains(filter));
      }).toList();
      isGeneralFilterApplied = true;
    });
  }

void _filterMealsByIngredients(List<String> inputIngredients) {
  setState(() {
    filteredMeals = meals.where((meal) {
      // Ensure all input ingredients partially match the meal's ingredients
      return inputIngredients.every((input) =>
          meal.ingredients.any((ingredient) =>
              ingredient.toLowerCase().contains(input)));
    }).toList();

    isIngredientsFiltered = true; // Track that ingredients filter is applied
  });
}


  void _clearFilters() {
    setState(() {
      filteredMeals = meals; // Reset to all meals
      isGeneralFilterApplied = false;
      isIngredientsFiltered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40), // Space for the status bar
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Explore Food Recipes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: isGeneralFilterApplied
                      ? OutlinedButton(
                          onPressed: _clearFilters,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            side: const BorderSide(color: Colors.black),
                          ),
                          child: const Text('Clear Filters', style: TextStyle(fontSize: 12),),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => FilterPopup(
                                onApply: _filterMealsByGeneral, // Pass filters
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Filter'),
                        ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: isIngredientsFiltered
                      ? OutlinedButton(
                          onPressed: _clearFilters,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            side: const BorderSide(color: Colors.black),
                          ),
                          child: const Text('Clear Ingredients', style: TextStyle(fontSize: 12),),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => IngredientsPopup(
                                onFilter: _filterMealsByIngredients, // Pass ingredients
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Ingredients'),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: GridView.builder(
                padding: EdgeInsets.all(0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.70,
                ),
                itemCount: filteredMeals.length,
                itemBuilder: (context, index) {
                  final meal = filteredMeals[index];
                  return MealCard(
                    mealName: meal.name,
                    description: meal.description,
                    imageUrl: meal.imageUrl,
                    timeToCook: meal.timeToCook,
                    calories: meal.calories,
                    ingredients: meal.ingredients,
                    preparation: meal.preparation, // Pass preparation steps
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
