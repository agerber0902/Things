import 'package:flutter/material.dart';
import 'package:things_app/helpers/firebase_helper.dart';
import 'package:things_app/models/category.dart';
import 'package:things_app/models/thing.dart';
import 'package:things_app/screens/categories_screen.dart';

import 'package:things_app/widgets/add_thing.dart';
import 'package:things_app/widgets/filter_modal.dart';
import 'package:things_app/widgets/search_bar.dart';
import 'package:things_app/widgets/things_list_view.dart';

final ThingsFirebaseHelper _firebaseHelper = ThingsFirebaseHelper();

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

    _searchValue = '';
    //Get things calls set state and updates _thingsToDisplay
    _getThings();

    _filterIconData = Icons.filter_list;

    _availableFilters = categoryIcons.entries.map((category) {
      return {MapEntry(category.key, category.value): false};
    }).toList();
  }

  void _addThing(Thing thingToAdd) async {
    await _firebaseHelper.postThing(thingToAdd);

    _getThings();
  }

  void _editThing(Thing thingToEdit) async {
    await _firebaseHelper.putThing(thingToEdit);

    _getThings();
  }

  void _deleteThing(Thing thingToDelete) async {
    await _firebaseHelper.deleteThing(thingToDelete);

    _getThings();
  }

  void _getThings() async {
    List<Thing> thingsToReturn = await _firebaseHelper.getThings();

    List<String> filterValues = _availableFilters
        .where((filter) => filter.entries.first.value)
        .map((filter) => filter.entries.first.key.key)
        .toList();

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
              (thing.description != null &&
                  thing.description!.toLowerCase().contains(_searchValue)) ||
              thing.categories.any(
                  (category) => category.toLowerCase().contains(_searchValue)))
          .toList();
    }

    setState(() {
      _thingsToDisplay = thingsToReturn;
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
          CollapsableSearchBar(searchThings: _searchThings),
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
            const DrawerHeader(
              child: Center(
                child: Text('Header Placeholder'),
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
                // Implement what you want to happen when Reminders is tapped
                Navigator.pop(context);
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
