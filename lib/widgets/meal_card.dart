import 'package:flutter/material.dart';
import '../screens/meal_details_screen.dart';

class MealCard extends StatelessWidget {
  final String mealName;
  final String description;
  final String imageUrl;
  final int timeToCook;
  final int calories;
  final List<String> ingredients;
  final List<String> preparation; // Add preparation steps field

  const MealCard({
    required this.mealName,
    required this.description,
    required this.imageUrl,
    required this.timeToCook,
    required this.calories,
    required this.ingredients,
    required this.preparation, // Initialize preparation steps
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealDetailsScreen(
              mealName: mealName,
              imageUrl: imageUrl,
              description: description,
              timeToCook: timeToCook,
              calories: calories,
              ingredients: ingredients,
              preparation: preparation, // Pass preparation steps
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: 175,
              height: 175,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  mealName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${ingredients.length} ingredients',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
