import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  List<String> _categories = [];
  List<String> get categories => _categories.where((sc) => sc != '').toList();
  
  void setCategoriesForEdit(List<String> categoriesForEdit){
    _categories = categoriesForEdit;
    print(_categories);
    notifyListeners();
  }
  void addcategory(String category) {
    _categories = [category, ..._categories];
    print(_categories);
    notifyListeners();
  }
  void deletecategory(String category) {
    _categories.remove(category);
    print(_categories);
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