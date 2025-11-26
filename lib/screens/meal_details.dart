import 'package:flutter/material.dart';
import '../models/meal_details.dart';
import '../services/ApiService.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;

  const MealDetailScreen({super.key, required this.mealId});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  MealDetail? _meal;

  @override
  void initState() {
    super.initState();
    _loadMeal();
  }

  void _loadMeal() async {
    final meal = await _apiService.fetchMealDetail(widget.mealId);
    setState(() {
      _meal = meal;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_meal?.name ?? "Meal Detail")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _meal == null
          ? const Center(child: Text("Meal not found"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(_meal!.thumbnail),
                  const SizedBox(height: 12),
                  Text(
                    _meal!.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Ingredients:",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  ..._meal!.ingredients.map((i) => Text("• $i")).toList(),
                  const SizedBox(height: 12),
                  Text(
                    "Instructions:",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(_meal!.instructions),
                  const SizedBox(height: 12),
                ],
              ),
            ),
    );
  }
}
