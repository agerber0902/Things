import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:things_app/helpers/file_manager.dart';
import 'package:things_app/models/reminder.dart';
import 'package:things_app/widgets/add_reminder.dart';
import 'package:things_app/widgets/reminders_list_view.dart';
import 'package:things_app/widgets/search_bar.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final ReminderFileManager fileManager = ReminderFileManager();

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

    //Check for things list and verify it exists. should exist unless its the first time on the screen.
    fileManager.verifyRemindersList();

    //Get Reminders calls set state and updates _RemindersToDisplay
    _getReminders();

    //_filterIconData = Icons.filter_list;
  }

  void _editReminderNotification(Reminder reminder) {
    int notificationId = _remindersToDisplay.indexWhere((r) => r.id == reminder.id);
    _deleteReminderNotification(notificationId);
    _scheduleReminderNotification(reminder);
  }

  void _deleteReminderNotification(int id) {
    //int id = _remindersToDisplay.indexWhere((r) => r.id == reminder.id);

    AwesomeNotifications().cancel(id);
  }

  void _scheduleReminderNotification(Reminder reminder) {
    int id = _remindersToDisplay.indexWhere((r) => r.id == reminder.id);

    tz.initializeTimeZones();
    final String localTimeZone = tz.local.name;

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id != -1 ? id : _remindersToDisplay.length,
        channelKey: 'reminders_channel',
        title: reminder.title,
        body: reminder.message,
      ),
      schedule: NotificationCalendar(
        year: reminder.date.year,
        month: reminder.date.month,
        day: reminder.date.day,
        hour: reminder.date.hour,
        minute: reminder.date.minute,
        second: reminder.date.second,
        millisecond: reminder.date.millisecond,
        timeZone: localTimeZone,
        repeats: false, // set to true to repeat the notification
      ),
    );
  }

  void _addReminder(Reminder reminderToAdd) async {
    await fileManager.addReminder(reminderToAdd);
    _scheduleReminderNotification(reminderToAdd);

    _getReminders();
  }

  void _editReminder(Reminder reminderToEdit) async {
    await fileManager.updateReminder(reminderToEdit);
    _editReminderNotification(reminderToEdit);

    _getReminders();
  }

  void _deleteReminder(Reminder reminderToDelete) async {
    int id = _remindersToDisplay.indexWhere((r) => r.id == reminderToDelete.id);
    
    await fileManager.deleteReminder(reminderToDelete);
    
    _deleteReminderNotification(id);

    _getReminders();
  }

  void _getReminders() async {
    List<Reminder> remindersToReturn = await fileManager.readReminderList();

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
            child: CollapsableSearchBar(
                expandedWidth: 250, searchThings: (value) {}),
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
