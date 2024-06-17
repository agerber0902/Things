import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:things_app/helpers/file_manager.dart';
import 'package:things_app/models/reminder.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final ReminderFileManager _fileManager = ReminderFileManager();

class ReminderProvider extends ChangeNotifier {
  //Search Value
  String _searchValue = '';
  String get searchValue => _searchValue;
  void setSearchValue(String value) {
    _searchValue = value;

    //call getReminders when search is changed
    getReminders();
  }

  //Active Reminder (typically in edit)
  //This gets set when a Reminder is selected.
  Reminder? _activeReminder;
  Reminder? get activeReminder => _activeReminder;

  void setActiveReminder(Reminder Reminder) {
    _activeReminder = Reminder;
    notifyListeners();
  }

  //Reminders for Display
  List<Reminder> _reminders = [];
  List<Reminder> get reminders => _reminders;

  //Get the list of Reminders
  void getReminders() async {
    _reminders = await _fileManager.readReminderList();

    //Search the reminders
    _searchReminders();

    notifyListeners();
  }

  //Add Reminder to List
  void addReminder(Reminder reminder) async {
    await _fileManager.addReminder(reminder);

    //This will notify listeners
    getReminders();
  }

  //Delete Reminder from List
  void deleteReminder(Reminder reminder) async {
    //Remove from the list of Reminders first to avoid widget tree error
    _reminders.remove(reminder);

    await _fileManager.deleteReminder(reminder);

    //This will notify listeners
    getReminders();
  }

  void editReminder(Reminder reminder) async {
    await _fileManager.updateReminder(reminder);

    //This will notify listeners
    getReminders();
  }

  //Search Reminders
  void _searchReminders() {
    if (_searchValue != '') {
      _reminders = _reminders
          .where((reminder) =>
              reminder.title.toLowerCase().contains(_searchValue) ||
              reminder.message.toLowerCase().contains(_searchValue))
          .toList();
    }
  }

//Notifications
  void editReminderNotification(Reminder reminder) {
    int notificationId = _reminders.indexWhere((r) => r.id == reminder.id);
    deleteReminderNotification(notificationId);
    scheduleReminderNotification(reminder);
  }

  void deleteReminderNotification(int id) {
    //int id = _remindersToDisplay.indexWhere((r) => r.id == reminder.id);

    AwesomeNotifications().cancel(id);
  }

  void scheduleReminderNotification(Reminder reminder) {
    int id = _reminders.indexWhere((r) => r.id == reminder.id);

    tz.initializeTimeZones();
    final String localTimeZone = tz.local.name;

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id != -1 ? id : _reminders.length,
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
}
