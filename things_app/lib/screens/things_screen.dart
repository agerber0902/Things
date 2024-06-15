import 'package:flutter/material.dart';
import 'package:things_app/models/category.dart';
import 'package:things_app/models/thing.dart';
import 'package:things_app/screens/categories_screen.dart';
import 'package:things_app/screens/reminders_screen.dart';

import 'package:things_app/widgets/things/add_thing.dart';
import 'package:things_app/widgets/filter_modal.dart';
import 'package:things_app/widgets/shared/appbar/search_bar.dart';
import 'package:things_app/widgets/things/things_list_view.dart';

import 'package:things_app/helpers/file_manager.dart';

final ThingFileManager fileManager = ThingFileManager();

class ThingsScreen extends StatefulWidget {
  const ThingsScreen({super.key});

  @override
  State<ThingsScreen> createState() => _ThingsScreenState();
}

class _ThingsScreenState extends State<ThingsScreen> {
  List<Thing> _thingsToDisplay = [];
  late List<Map<MapEntry<String, CategoryIcon>, bool>> _availableFilters;
  late IconData? _filterIconData;
  late String _searchValue;

  @override
  void initState() {
    super.initState();

    //Check for things list and verify it exists. should exist unless its the first time on the screen.
    fileManager.verifyThingsList();

    _searchValue = '';

    //Get things calls set state and updates _thingsToDisplay
    _getThings();

    _filterIconData = Icons.filter_list;

    _availableFilters = categoryIcons.entries.map((category) {
      return {MapEntry(category.key, category.value): false};
    }).toList();
  }

  void _addThing(Thing thingToAdd) async {
    await fileManager.addThing(thingToAdd);

    _getThings();
  }

  void _editThing(Thing thingToEdit) async {
    await fileManager.updateThing(thingToEdit);

    _getThings();
  }

  void _deleteThing(Thing thingToDelete) async {
    //await _firebaseHelper.deleteThing(thingToDelete);
    await fileManager.deleteThing(thingToDelete);

    _getThings();
  }

  void _getThings() async {
    List<Thing> thingsToReturn = await fileManager.readThingList();

    List<String> filterValues = _availableFilters
        .where((filter) => filter.entries.first.value)
        .map((filter) => filter.entries.first.key.key)
        .toList();

    //Filter the completed things
    if (filterValues.contains('complete')) {
      //remove complete from the filter values, then continue as usual
      filterValues.remove('complete');

      thingsToReturn =
          thingsToReturn.where((thing) => thing.isMarkedComplete).toList();
    }

    //Filter the things
    if (filterValues.isNotEmpty) {
      thingsToReturn = thingsToReturn
          .where((thing) => thing.categories
              .any((category) => filterValues.contains(category)))
          .toList();
    }

    //Search the things
    if (_searchValue.trim().isNotEmpty) {
      thingsToReturn = thingsToReturn
          .where((thing) =>
              thing.title.toLowerCase().contains(_searchValue) ||
              (thing.description!.toLowerCase().contains(_searchValue)) ||
              thing.categories.any(
                  (category) => category.toLowerCase().contains(_searchValue)))
          .toList();

      //search on notes
      thingsToReturn = thingsToReturn
          .where((thing) =>
              thing.notes == null ||
              thing.notes!
                  .any((note) => note.toLowerCase().contains(_searchValue)))
          .toList();
    }

    //Start by filtering out marked as complete.
    //Get list of things marked as complete, add them to the end of the list
    List<Thing> completedThings =
        thingsToReturn.where((thing) => thing.isMarkedComplete).toList();
    thingsToReturn =
        thingsToReturn.where((thing) => !thing.isMarkedComplete).toList();

    //Then filter out the favorites
    //Get list of favorite things, add them to the beginning of the list
    List<Thing> favoriteThings = thingsToReturn
        .where((thing) => thing.categories.contains('favorite'))
        .toList();

    //finally filter out the things
    //Get list of things that are NOT favorites or complete, and those will go in the middle
    List<Thing> things = thingsToReturn
        .where((thing) =>
            !thing.isMarkedComplete && !thing.categories.contains('favorite'))
        .toList();

    setState(() {
      //_thingsToDisplay = thingsToReturn;
      _thingsToDisplay = [...favoriteThings, ...things, ...completedThings];
    });
  }

  Future<void> _dialogBuilder(
    BuildContext context,
    List<Map<MapEntry<String, CategoryIcon>, bool>> availableFilters,
    void Function(String categoryName, bool switchValue) updateFilters,
    void Function() resetFilters,
    void Function(List<Map<MapEntry<String, CategoryIcon>, bool>> filters)
        saveFilters,
  ) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return FilterDialog(
              availableFilters: availableFilters,
              updateFilters: updateFilters,
              resetFilters: resetFilters,
              saveFilters: saveFilters,
            );
          });
        });
  }

  void _updateFilters(String categoryName, bool switchValue) {
    setState(() {
      final filterMap = _availableFilters.firstWhere((filterMap) {
        return filterMap.keys.any((entry) => entry.key == categoryName);
      });

      final entry =
          filterMap.keys.firstWhere((entry) => entry.key == categoryName);

      filterMap[entry] = switchValue;
    });
  }

  void _resetFilters() {
    setState(() {
      _availableFilters = categoryIcons.entries.map((category) {
        return {MapEntry(category.key, category.value): false};
      }).toList();

      //Update filter image
      _setFilterImage(0);
    });

    _getThings();
  }

  void _openFilters() {
    _dialogBuilder(context, _availableFilters, _updateFilters, _resetFilters,
        _saveFilters);
  }

  void _setFilterImage(int filterCount) {
    setState(() {
      switch (filterCount) {
        case 0:
          _filterIconData = Icons.filter_list;
          break;
        case 1:
          _filterIconData = Icons.filter_1;
          break;
        case 2:
          _filterIconData = Icons.filter_2;
          break;
        case 3:
          _filterIconData = Icons.filter_3;
          break;
        case 4:
          _filterIconData = Icons.filter_4;
          break;
        case 5:
          _filterIconData = Icons.filter_5;
          break;
        case 6:
          _filterIconData = Icons.filter_6;
          break;
        case 7:
          _filterIconData = Icons.filter_7;
          break;
        default:
          _filterIconData = Icons.filter_alt;
      }
    });
  }

  void _saveFilters(List<Map<MapEntry<String, CategoryIcon>, bool>> filters) {
    int filterCount =
        filters.where((filter) => filter.entries.first.value).length;

    setState(() {
      _availableFilters = filters;

      //Update filter image
      _setFilterImage(filterCount);
    });

    _getThings();
  }

  void _searchThings(String searchValue) {
    setState(() {
      _searchValue = searchValue;
    });

    _getThings();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Things',
          style: textTheme.headlineLarge!.copyWith(color: colorScheme.primary),
        ),
        actions: [
          //TODO: add back in
          //CollapsableSearchBar(expandedWidth: 200, searchThings: _searchThings),
          IconButton(
            onPressed: () {
              _openFilters();
            },
            icon: Icon(_filterIconData),
          ),
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (ctx) {
                      return AddThing(
                        addThing: _addThing,
                        editThing: _editThing,
                      );
                    });
              },
              icon: Icon(
                Icons.add,
                color: colorScheme.primary,
              )),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Center(
                child: Image.asset('assets/images/logo.png'),
              ),
            ),
            ListTile(
              title: const Text('Categories'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const CategoriesScreen()));
              },
            ),
            ListTile(
              title: const Text('Reminders'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const RemindersScreen()));
              },
            ),
            ListTile(
              title: const Text('Things'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return const ThingsScreen();
                }));
              },
            ),
          ],
        ),
      ),
      body: _thingsToDisplay.isEmpty
          ? const NoThingsView()
          : ThingsListView(
              things: _thingsToDisplay,
              deleteThing: _deleteThing,
              addThing: _addThing,
              editThing: _editThing,
            ),
    );
  }
}

class NoThingsView extends StatelessWidget {
  const NoThingsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No things!',
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: Colors.white,
                ),
          ),
          Text(
            'Add whatever you want!',
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(color: Colors.white.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }
}
