import 'package:flutter/material.dart';

import 'package:lab_app2/screens/category_screen.dart';
import 'package:lab_app2/screens/meal_details.dart';
import 'package:lab_app2/screens/meal_screen.dart';
import 'package:lab_app2/models/category_model.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Meals",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const MyHomePage(title: "Categories"),
        "/meals": (context) {
          final category =
              ModalRoute.of(context)!.settings.arguments as Category;
          return MealPageWithCategory(category: category);
        },
        "/meals_details": (context) {
          final mealId = ModalRoute.of(context)!.settings.arguments as String;
          return MealDetailScreen(mealId: mealId);
        },
      },
    );
  }
}
