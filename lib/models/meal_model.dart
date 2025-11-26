class Meal {
  String id;
  String name;
  String img;

  Meal({required this.id, required this.name, required this.img});

  Meal.fromJson(Map<String, dynamic> data)
    : id = data['idMeal'],
      name = data['strMeal'],
      img = data['strMealThumb'];

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'img': img};
}
