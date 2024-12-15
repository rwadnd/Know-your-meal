import 'package:firebase_database/firebase_database.dart';
import '../models/meal_model.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Fetch meals from Firebase
  Future<List<Meal>> fetchMeals() async {
    final snapshot = await _database.child('meals').get();
    if (snapshot.exists) {
      List<Meal> meals = [];
      Map data = snapshot.value as Map;
      data.forEach((key, value) {
        meals.add(Meal.fromMap(key, Map<String, dynamic>.from(value)));
      });
      return meals;
    } else {
      throw Exception('No meals found.');
    }
  }
}
