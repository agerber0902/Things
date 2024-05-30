import 'package:flutter/material.dart';
import 'package:things_app/helpers/reminders_firebase_helper.dart';
import 'package:things_app/models/reminder.dart';
import 'package:things_app/widgets/add_reminder.dart';
import 'package:things_app/widgets/reminders_list_view.dart';
import 'package:things_app/widgets/search_bar.dart';

final RemindersFirebaseHelper _firebaseHelper = RemindersFirebaseHelper();

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  List<Reminder> _remindersToDisplay = [];
  bool? isSearching;
  //late IconData? _filterIconData;
  //late String _searchValue;

  @override
  void initState() {
    super.initState();

    isSearching = false;

    //_searchValue = '';
    //Get Reminders calls set state and updates _RemindersToDisplay
    _getReminders();

    //_filterIconData = Icons.filter_list;
  }

  void _addReminder(Reminder reminderToAdd) async {
    await _firebaseHelper.postReminder(reminderToAdd);

    _getReminders();
  }

  void _editReminder(Reminder reminderToEdit) async {
    await _firebaseHelper.putReminder(reminderToEdit);

    _getReminders();
  }

  void _deleteReminder(Reminder reminderToDelete) async {
    await _firebaseHelper.deleteReminder(reminderToDelete);

    _getReminders();
  }

  void _getReminders() async {
    List<Reminder> remindersToReturn = await _firebaseHelper.getReminders();

    // List<String> filterValues = _availableFilters
    //     .where((filter) => filter.entries.first.value)
    //     .map((filter) => filter.entries.first.key.key)
    //     .toList();

    //Filter the Reminders
    // if (filterValues.isNotEmpty) {
    //   remindersToReturn = remindersToReturn
    //       .where((Reminder) => Reminder.categories
    //           .any((category) => filterValues.contains(category)))
    //       .toList();
    // }

    // //Search the Reminders
    // if (_searchValue.trim().isNotEmpty) {
    //   RemindersToReturn = RemindersToReturn
    //       .where((Reminder) =>
    //           Reminder.title.toLowerCase().contains(_searchValue) ||
    //           (Reminder.description != null &&
    //               Reminder.description!.toLowerCase().contains(_searchValue)) ||
    //           Reminder.categories.any(
    //               (category) => category.toLowerCase().contains(_searchValue)))
    //       .toList();
    // }

    setState(() {
      _remindersToDisplay = remindersToReturn;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reminders',
          style: textTheme.headlineLarge!.copyWith(color: colorScheme.primary),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                isSearching = isSearching == null ? false : !isSearching!;
              });
            },
            child: CollapsableSearchBar(expandedWidth: 250, searchThings: (value) {}),
          ),
          // IconButton(
          //   onPressed: () {
          //     //_openFilters();
          //   },
          //   icon: Icon(_filterIconData),
          // ),
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (ctx) {
                      return AddReminder(
                        addReminder: _addReminder,
                        editReminder: _editReminder,
                      );
                    });
              },
              icon: Icon(
                Icons.add,
                color: colorScheme.primary,
              )),
        ],
      ),
      body: _remindersToDisplay.isEmpty
          ? const NoRemindersView()
          : RemindersListView(
              reminders: _remindersToDisplay,
              deleteReminder: _deleteReminder,
              addReminder: _addReminder,
              editReminder: _editReminder,
            ),
    );
  }
}

class NoRemindersView extends StatelessWidget {
  const NoRemindersView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No Reminders!',
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
