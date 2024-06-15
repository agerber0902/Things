import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier{

  //String value from the search bar
  String _searchValue = '';
  String get searchValue => _searchValue;

  //Set the search value
  void setSearchValue(String value){
    _searchValue = value;
    notifyListeners();
  }

}