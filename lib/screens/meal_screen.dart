import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../models/category_model.dart';
import '../services/ApiService.dart';
import '../widgets/meal_widgets/meal_grid.dart';

class MealPageWithCategory extends StatefulWidget {
  final Category category;

  const MealPageWithCategory({super.key, required this.category});

  @override
  State<MealPageWithCategory> createState() => _MealPageWithCategoryState();
}

class _MealPageWithCategoryState extends State<MealPageWithCategory> {
  List<Meal> _meals = [];
  List<Meal> _filteredMeals = [];
  bool _isLoading = true;

  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMealList();
  }

  void _loadMealList() async {
    final mealList = await _apiService.loadMealList(
      categoryName: widget.category.name,
    );

    setState(() {
      _meals = mealList;
      _filteredMeals = mealList;
      _isLoading = false;
    });
  }

  void _filterMeals(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredMeals = _meals;
      } else {
        _filteredMeals = _meals
            .where((m) => m.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search meal...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: _filterMeals,
                  ),
                ),
                Expanded(
                  child: _filteredMeals.isEmpty
                      ? const Center(child: Text("No meals found."))
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: MealGrid(meal: _filteredMeals),
                        ),
                ),
              ],
            ),
    );
  }
}
