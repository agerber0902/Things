import 'package:flutter/material.dart';
import 'package:things_app/helpers/file_manager.dart';
import 'package:things_app/models/category.dart';
import 'package:things_app/models/reminder.dart';
import 'package:things_app/models/thing.dart';
import 'package:things_app/utils/icon_data.dart';

final ThingFileManager _fileManager = ThingFileManager();

class ThingsProvider extends ChangeNotifier {
  //Thing that should be used when in edit mode
  Thing? _thingInEdit;
  Thing? get thingInEdit => _thingInEdit;
  bool get isEditMode => thingInEdit != null;
  void setThingInEdit(Thing? thing) {
    _thingInEdit = thing;
    notifyListeners();
  }

  List<Thing> _things = [];
  List<Thing> get things => _things;

  //Get the list of things
  void getThings() async {
    _things = await _fileManager.readThingList();

    //Apply Filters
    _things = _filterThings();

    //Apply Search
    _things = _searchThings();

    //Apply Sort
    _things = _sortThings();

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
    //Remove from the list of things first to avoid widget tree error
    _things.remove(thing);

    await _fileManager.deleteThing(thing);

    //This will notify listeners
    getThings();
  }

  //Edit Thing from List
  void editThing(Thing thing) async {
    await _fileManager.updateThing(thing);

    //This will notify listeners
    getThings();
  }

  List<Thing> _filterThings() {
    List<String> filterValues = _selectedFilters
        .where((filter) => filter.entries.first.value)
        .map((filter) => filter.entries.first.key.key)
        .toList();

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

    return filteredThings;
  }

  List<Thing> _searchThings() {
    List<Thing> searchedThings = _things;

    if (_searchValue.trim().isNotEmpty) {
      searchedThings = _things
          .where((thing) =>
              (thing.title.toLowerCase().contains(_searchValue)) ||
              (thing.description.toLowerCase().contains(_searchValue)) ||
              (thing.categories.any(
                  (category) => category.toLowerCase().contains(_searchValue))))
          .toList();

      //Search on notes
      List<Thing> thingsWithNotes = _things
          .where((thing) => thing.notes != null)
          .where((t) =>
              t.notes!.any((note) => note.toLowerCase().contains(_searchValue)))
          .toList();

      // Combine the results and remove duplicates
      searchedThings = (searchedThings + thingsWithNotes).toSet().toList();
    }

    return searchedThings;
  }

  List<Thing> _sortThings() {
    List<Thing> thingsToSort = _things;

    thingsToSort.sort((a, b) {
      bool aIsFavorite = a.categories.any((category) => category.toLowerCase() == 'favorite');
      bool bIsFavorite = b.categories.any((category) => category.toLowerCase() == 'favorite');
      if (aIsFavorite && !bIsFavorite) return -1;
      if (!aIsFavorite && bIsFavorite) return 1;
      return 0;
    });

    List<Thing> completedThings =
        thingsToSort.where((thing) => thing.isMarkedComplete).toList();
    //Remove completed things from list
    thingsToSort =
        thingsToSort.where((thing) => !thing.isMarkedComplete).toList();

    List<Thing> favoriteThings = thingsToSort
        .where((thing) => thing.categoriesContainsFavorite)
        .toList();
    
    //Remove completed things from list - we know that this will be the rest of the things, so shove them in the middle
    List<Thing> remainingThings =
        thingsToSort.where((thing) => !thing.categoriesContainsFavorite).toList();
    
    List<Thing> sortedThings = [...favoriteThings, ...remainingThings, ...completedThings];

    return sortedThings;
  }

//Reminders
  List<Reminder> _remindersForThing = [];
  List<Reminder> get remindersForThing => _remindersForThing;

  void addReminderForThing(Reminder reminder) {
    _remindersForThing = [reminder, ..._remindersForThing];
    notifyListeners();
  }

  void deleteReminderForThing(Reminder reminder) {
    _remindersForThing.remove(reminder);
    notifyListeners();
  }

  void resetRemindersForThing() {
    _remindersForThing = [];
    notifyListeners();
  }

  void setRemindersForThing(List<Reminder> reminders) {
    _remindersForThing = reminders;
    notifyListeners();
  }

  Thing? getById(String id) {
    try {
      return _things.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  //Filters
  final List<Map<MapEntry<String, CategoryIcon>, bool>> _availableFilters =
      categoryIcons.entries.map((category) {
    return {MapEntry(category.key, category.value): false};
  }).toList();
  List<Map<MapEntry<String, CategoryIcon>, bool>> get availableFilters =>
      _availableFilters;

  List<Map<MapEntry<String, CategoryIcon>, bool>> _selectedFilters = [];
  List<Map<MapEntry<String, CategoryIcon>, bool>> get selectedFilters =>
      _selectedFilters;

  void updateFilters(String categoryName, bool switchValue) {
    final filterMap = _availableFilters.firstWhere((filterMap) {
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
    setFilterImage();

    getThings();
  }

  void saveFilters() {
    setFilterImage();
    //call get things
    //This will notifiy the listeners and use the _selectedFilters for filtering
    getThings();
  }

  Icon _filterIcon = filterListIcon;
  Icon get filterIcon => _filterIcon;

  void setFilterImage() {
    int filterCount = selectedFilters.length;

    switch (filterCount) {
      case 0:
        _filterIcon = filterListIcon;
        break;
      case 1:
        _filterIcon = filter1Icon;
        break;
      case 2:
        _filterIcon = filter2Icon;
        break;
      case 3:
        _filterIcon = filter3Icon;
        break;
      case 4:
        _filterIcon = filter4Icon;
        break;
      case 5:
        _filterIcon = filter5Icon;
        break;
      case 6:
        _filterIcon = filter6Icon;
        break;
      case 7:
        _filterIcon = filter7Icon;
        break;
      default:
        _filterIcon = filterAltIcon;
    }
  }

//Search
  String _searchValue = '';
  String get serchValue => _searchValue;

  void setSearchValue(String value) {
    _searchValue = value.trim().toLowerCase();

    getThings();
  }
}
