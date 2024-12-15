import 'package:flutter/material.dart';

class MealDetailsScreen extends StatelessWidget {
  final String mealName;
  final String imageUrl;
  final String description;
  final int timeToCook;
  final int calories;
  final List<String> ingredients;
  final List<String> preparation;

  const MealDetailsScreen({
    required this.mealName,
    required this.imageUrl,
    required this.description,
    required this.timeToCook,
    required this.calories,
    required this.ingredients,
    required this.preparation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Meal Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Image.network(
                imageUrl,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Back Arrow
          Positioned(
            top: 40,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Color.fromARGB(255, 255, 255, 255),
                size: 28,
              ),
            ),
          ),
          // Content
          Positioned.fill(
            top: 260,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Meal Name
                    Text(
                      mealName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Description
                    Text(
                      description,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    // Time and Calories
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Time to cook: $timeToCook min',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Calories: $calories',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Ingredients
                    const Text(
                      'Ingredients: (per person)',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: ingredients
                          .map((ingredient) => Text(
                                '- $ingredient',
                                style: const TextStyle(fontSize: 14),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    // Preparation
                    const Text(
                      'Preparation:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: preparation
                          .map((step) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  '- $step',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
