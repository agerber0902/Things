import 'package:flutter/material.dart';
import 'package:things_app/helpers/file_manager.dart';
import 'package:things_app/models/thing.dart';

ThingFileManager _fileManager = ThingFileManager();

class ThingProvider extends ChangeNotifier{
  

  //Search Value
  String _searchValue = '';
  String get searchValue => _searchValue;
  void setSearchValue(String value){
    _searchValue = value;
    getThings();
  }

    //Things for Display
  List<Thing> _things = [];
  List<Thing> get things => _things;

  //Get the list of Things
  void getThings() async {
    _things = await _fileManager.readThingList();

    //Search the things
    _searchThings();

    notifyListeners();
  }

  //Add Thing to List
  void addThing(Thing thing) async {
    await _fileManager.addThing(thing);

    //This will notify listeners
    getThings();
  }

  //Delete Thing from List
  void deleteThing(Thing thing) async {
    //Remove from the list of Things first to avoid widget tree error
    _things.remove(thing);

    await _fileManager.deleteThing(thing);

    //This will notify listeners
    getThings();
  }

  void editThing(Thing thing) async {
    await _fileManager.updateThing(thing);

    //This will notify listeners
    getThings();
  }

  //Search Things
  void _searchThings() {
    if (_searchValue != '') {
      _things = _things
          .where((thing) =>
              thing.title.toLowerCase().contains(_searchValue) ||
              thing.description.toLowerCase().contains(_searchValue))
          .toList();
    }
  }


  
}