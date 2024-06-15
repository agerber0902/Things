import 'package:flutter/material.dart';

class ThingProvider extends ChangeNotifier{
  

  //Search Value
  String _searchValue = '';
  String get searchValue => _searchValue;
  void setSearchValue(String value){
    _searchValue = value;
    notifyListeners();
  }

  
}