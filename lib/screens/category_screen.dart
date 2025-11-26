import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/ApiService.dart';
import '../widgets/category_widgets/category_grid.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final List<Category> _category;
  List<Category> _filteredCategory = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String _searchQuery = '';
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategoryList(n: 20);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Category by name...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                      _filterCategory(value);
                    },
                  ),
                ),
                Expanded(
                  child: _filteredCategory.isEmpty && _searchQuery.isNotEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No Category found',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: _isSearching
                                    ? null
                                    : () async {
                                        await _searchCategoryByName(
                                          _searchQuery,
                                        );
                                      },
                                child: _isSearching
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Search in API'),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: CategoryGrid(category: _filteredCategory),
                        ),
                ),
              ],
            ),
    );
  }

  void _loadCategoryList({required int n}) async {
    final categoryList = await _apiService.loadCategoryList(n: n);

    setState(() {
      _category = categoryList;
      _filteredCategory = categoryList;
      _isLoading = false;
    });
  }

  void _filterCategory(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredCategory = _category;
      } else {
        _filteredCategory = _category
            .where(
              (category) =>
                  category.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  Future<void> _searchCategoryByName(String name) async {
    if (name.isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    final category = await _apiService.searchCategoryByName(name);

    setState(() {
      _isSearching = false;
      if (category != null) {
        _filteredCategory = [category];
      } else {
        _filteredCategory = [];
      }
    });
  }
}
