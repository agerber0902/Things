import 'package:flutter/material.dart';
import 'package:things_app/helpers/file_manager.dart';
import 'package:things_app/models/thing.dart';

ThingFileManager _fileManager = ThingFileManager();

class ThingProvider extends ChangeNotifier {
  //Search Value
  String _searchValue = '';
  String get searchValue => _searchValue;
  void setSearchValue(String value) {
    _searchValue = value;
    getThings();
  }

  //Filter value
  List<String> _filterValues = [];
  List<String> get filterValues => _filterValues;

  void setFilterValues(List<String> filters) {
    _filterValues = filters;

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

    //Filter Things
    _filterThings();

    //Sort Things
    _sortThings();

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

  //Sort Things
  void _sortThings(){

    //sort things by favorite
     _things.sort((a, b) {
      bool aIsFavorite = a.categories.any((category) => category.toLowerCase() == 'favorite');
      bool bIsFavorite = b.categories.any((category) => category.toLowerCase() == 'favorite');
      if (aIsFavorite && !bIsFavorite) return -1;
      if (!aIsFavorite && bIsFavorite) return 1;
      return 0;
    });

    //Start by filtering out marked as complete.
    //Get list of things marked as complete, add them to the end of the list
    List<Thing> completedThings = _things.where((thing) => thing.isMarkedComplete).toList();

    _things = _things.where((thing) => !thing.isMarkedComplete).toList();

    //Then filter out the favorites
    //Get list of favorite things, add them to the beginning of the list
    List<Thing> favoriteThings = _things
        .where((thing) => thing.categories.contains('favorite'))
        .toList();

    //finally filter out the things
    //Get list of things that are NOT favorites or complete, and those will go in the middle
    List<Thing> remainingThings = _things
        .where((thing) =>
            !thing.isMarkedComplete && !thing.categories.contains('favorite'))
        .toList();

    _things = [...favoriteThings, ...remainingThings, ...completedThings];
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

  //Filter Things
  void _filterThings() {
    if (filterValues.isNotEmpty) {
      List<Thing> filteredThings = _things;

      //Filter by completed things - remove complete afterwards for special case
      if (filterValues.contains('complete')) {
        //remove complete from the filter values, then continue as usual
        filterValues.remove('complete');

        filteredThings =
            filteredThings.where((thing) => thing.isMarkedComplete).toList();
      }

      //Filter the things
      if (filterValues.isNotEmpty) {
        filteredThings = filteredThings
            .where((thing) => thing.categories
                .any((category) => filterValues.contains(category)))
            .toList();
      }

      _things = filteredThings;
    }
  }
}
