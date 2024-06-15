import 'package:flutter/material.dart';
import 'package:things_app/models/category.dart';

class FilterProvider extends ChangeNotifier {
  //All Filters
  List<Map<MapEntry<String, CategoryIcon>, bool>> _filters =
      categoryIcons.entries.map((category) {
    return {MapEntry(category.key, category.value): false};
  }).toList();
  List<Map<MapEntry<String, CategoryIcon>, bool>> get filters => _filters;

  //SelectedFilters
  List<Map<MapEntry<String, CategoryIcon>, bool>> _selectedFilters = [];
  List<Map<MapEntry<String, CategoryIcon>, bool>> get selectedFilters =>
      _selectedFilters;

  List<String> get filtersForThing => _selectedFilters
      .where((filter) => filter.entries.first.value)
      .map((filter) => filter.entries.first.key.key)
      .toList();

  void updateFilters(String categoryName, bool switchValue) {
    final filterMap = _filters.firstWhere((filterMap) {
      return filterMap.keys.any((entry) => entry.key == categoryName);
    });

    final entry =
        filterMap.keys.firstWhere((entry) => entry.key == categoryName);

    filterMap[entry] = switchValue;

    if (switchValue) {
      _selectedFilters.add(filterMap);
    } else {
      _selectedFilters.remove(filterMap);
    }
  }

  void resetFilters() {
    _selectedFilters = [];

    _filters = categoryIcons.entries.map((category) {
      return {MapEntry(category.key, category.value): false};
    }).toList();

    notifyListeners();
  }
}
