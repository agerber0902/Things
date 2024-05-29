import 'package:flutter/material.dart';

// const Map<String, IconData> categoryIcons = {
//     //'favorite': Icons.favorite,
//     'house': Icons.home,
//     //'settings': Icons.settings,
//     'restaurants': Icons.dining,
//     'recipes': Icons.restaurant,
//     'chores': Icons.agriculture_sharp,
//     'vacation': Icons.beach_access,
// };

const Map<String, CategoryIcon> categoryIcons = {

  'house' : CategoryIcon('house', Icons.home, Colors.deepPurpleAccent),
  'favorite' : CategoryIcon('favorite', Icons.favorite, Colors.red),
  'restaurants' : CategoryIcon('restaurants', Icons.restaurant, Colors.blue),
  'drinks' : CategoryIcon('drinks', Icons.local_drink, Colors.deepOrange),
  'recipes' : CategoryIcon('recipes', Icons.dining, Colors.amber),
  'chores' : CategoryIcon('chores', Icons.agriculture_sharp, Colors.green),
  'vacation' : CategoryIcon('vacation', Icons.beach_access, Colors.pink),

};

class CategoryIcon {
  final String name;
  final IconData iconData;
  final Color iconColor;

  const CategoryIcon(this.name, this.iconData, this.iconColor);
}