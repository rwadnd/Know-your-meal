import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';
import '../models/meal_model.dart';
import '../screens/meal_details_screen.dart';
import '../widgets/filter_popup.dart';

class MealOfDayScreen extends StatefulWidget {
  const MealOfDayScreen({super.key});

  @override
  _MealOfDayScreenState createState() => _MealOfDayScreenState();
}

class _MealOfDayScreenState extends State<MealOfDayScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  List<Meal> meals = [];
  List<Meal> filteredMeals = [];
  Meal selectedMeal = Meal(
    name: '????',
    description: '',
    imageUrl: 'https://i.ibb.co/Drr3T20/question-mark.jpg',
    timeToCook: 0,
    calories: 0,
    ingredients: [],
    filters: [],
    preparation: [],
  );
  bool isFilterApplied = false;
  bool isLoading = true;

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
          return Meal.fromMap(
              entry.key, Map<String, dynamic>.from(entry.value));
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

  void _pickRandomMeal() {
    if (filteredMeals.isNotEmpty) {
      final random = Random();
      setState(() {
        selectedMeal = filteredMeals[random.nextInt(filteredMeals.length)];
      });
    }
  }

  void _showFilterPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FilterPopup(
        onApply: (filters) {
          setState(() {
            filteredMeals = meals.where((meal) {
              return filters.every((filter) => meal.filters.contains(filter));
            }).toList();
            isFilterApplied = filters.isNotEmpty;

            if (filteredMeals.isEmpty) {
              selectedMeal = Meal(
                name: '????',
                description: '',
                imageUrl: 'https://i.ibb.co/Drr3T20/question-mark.jpg',
                timeToCook: 0,
                calories: 0,
                ingredients: [],
                filters: [],
                preparation: [],
              );
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40), // Space for the status bar
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Let Us Choose Your Meal Today',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: isFilterApplied
                              ? OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      filteredMeals = meals;
                                      isFilterApplied = false;
                                      selectedMeal = Meal(
                                        name: '????',
                                        description: '',
                                        imageUrl:
                                            'https://i.ibb.co/Drr3T20/question-mark.jpg',
                                        timeToCook: 0,
                                        calories: 0,
                                        ingredients: [],
                                        filters: [],
                                        preparation: [],
                                      );
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    side: const BorderSide(color: Colors.black),
                                  ),
                                  child: const Text('Clear Filters'),
                                )
                              : ElevatedButton(
                                  onPressed: () => _showFilterPopup(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('Apply Filter'),
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade300,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (selectedMeal.name != '????') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MealDetailsScreen(
                                  mealName: selectedMeal.name,
                                  imageUrl: selectedMeal.imageUrl,
                                  description: selectedMeal.description,
                                  timeToCook: selectedMeal.timeToCook,
                                  calories: selectedMeal.calories,
                                  ingredients: selectedMeal.ingredients,
                                  preparation: selectedMeal.preparation,
                                ),
                              ),
                            );
                          }
                        },
                        child: Image.network(
                          selectedMeal.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    selectedMeal.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _pickRandomMeal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Surprise me'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
