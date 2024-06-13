import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  List<String> _categories = [];
  List<String> get categories => _categories.where((sc) => sc != '').toList();
  
  void addCategoriesForEdit(List<String> categoriesForEdit){
    _categories = categoriesForEdit;
    notifyListeners();
  }
  void addcategory(String category) {
    _categories = [category, ..._categories];
    notifyListeners();
  }
  void deletecategory(String category) {
    _categories.remove(category);
    notifyListeners();
  }
  void editcategory(String category, int index) {
    _categories[index] = category;
    notifyListeners();
  }
  void reset(){
    _categories = [];
  }
}
