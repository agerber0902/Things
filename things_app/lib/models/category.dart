import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

final uuid = const Uuid().v4();

const Map<String, IconData> categoryIcons = {
    //'favorite': Icons.favorite,
    'house': Icons.home,
    //'settings': Icons.settings,
    'restaurants': Icons.dining,
    'recipes': Icons.restaurant,
    'chores': Icons.agriculture_sharp,
    'vacation': Icons.beach_access,
};

class Category {
  final String id;
  final String name;
  final String iconName;

  const Category.toAdd({required this.id, required this.name, required this.iconName});
  Category({required this.name, required this.iconName}) : id = uuid;
}

class CategoryJsonHelper{
  List<Category> decodedCategories({required data}){

    List<Category> categoriesToReturn = [];
    for (final entry in data.entries) {
      categoriesToReturn.add(decodedCategory(entry: entry));
    }

    return categoriesToReturn;
  }

  Category decodedCategory({required entry}){

    final decodedCategory = Category.toAdd(
          id: entry.key,
          name: entry.value['name'],
          iconName: entry.value['iconName'],
        );

    return decodedCategory;
  }

  Map<String, Object> categoryToMap({required Category category}){
    final encodedCategory = {
      'name': category.name,
      'iconName': category.iconName,
    };
    return encodedCategory;
  }

}