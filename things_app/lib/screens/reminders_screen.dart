import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/helpers/file_manager.dart';
import 'package:things_app/providers/reminder_provider.dart';
import 'package:things_app/utils/reminders_setup.dart';
import 'package:things_app/widgets/reminders_list_view.dart';
import 'package:things_app/widgets/shared/appbar/shared_app_bar.dart';

final ReminderFileManager fileManager = ReminderFileManager();
final ThingFileManager thingFileManager = ThingFileManager();

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  bool? isSearching;
  //late IconData? _filterIconData;
  //late String _searchValue;

  @override
  void initState() {
    super.initState();

    isSearching = false;

    //Check for things list and verify it exists. should exist unless its the first time on the screen.
    fileManager.verifyRemindersList();

    //_filterIconData = Icons.filter_list;
  }

  @override
  Widget build(BuildContext context) {
    final RemindersSetup setup = RemindersSetup();

    return Scaffold(
      appBar: SharedAppBar(
        title: setup.title,
        actions: setup.appBarSetup.appBarActions,
      ),
      body: Consumer<ReminderProvider>(builder:(context, reminderProvider, child) {
        return reminderProvider.reminders.isEmpty
          ? const NoRemindersView()
          : const RemindersListView();
      },), 
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
