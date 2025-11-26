import 'dart:convert';
import '../models/meal_model.dart';
import '../models/category_model.dart';
import '../models/meal_details.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<Category>> loadCategoryList({required int n}) async {
    List<Category> categoryList = [];

    for (var i = 0; i < n; i++) {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final List categories = data['categories'];

        return categories.map((c) => Category.fromJson(c)).toList();
      }
    }

    return categoryList;
  }

  Future<List<Meal>> loadMealList({required String categoryName}) async {
    final response = await http.get(
      Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=$categoryName',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final List meals = data['meals'];

      return meals.map((meal) => Meal.fromJson(meal)).toList();
    } else {
      throw Exception("Failed to load meals for category $categoryName");
    }
  }

  Future<Meal?> searchMealByCategoryName(String name) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://www.themealdb.com/api/json/v1/1/search.php?s=${name.toLowerCase()}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Meal.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Category?> searchCategoryByName(String name) async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=$name'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Category.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<MealDetail?> fetchMealDetail(String id) async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final meals = data['meals'] as List;
      if (meals.isNotEmpty) {
        return MealDetail.fromJson(meals[0]);
      }
    }

    return null;
  }
}
