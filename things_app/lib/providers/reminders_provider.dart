import 'package:flutter/material.dart';
import 'package:things_app/helpers/file_manager.dart';
import 'package:things_app/models/reminder.dart';

final ReminderFileManager _fileManager = ReminderFileManager();

class RemindersProvider extends ChangeNotifier {
  List<Reminder> _reminders = [];
  List<Reminder> get reminders => _reminders;

  //Get the list of Reminders
  void getReminders() async {
    _reminders = await _fileManager.readReminderList();
    
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

  void editReminder(Reminder reminder, int index) async{
    _reminders[index] = reminder;

    await _fileManager.updateReminder(reminder);

    //This will notify listeners
    getReminders();
  }

  void addThingIdsToReminders(List<String> reminderIds, String thingId) async{

    for(Reminder reminder in reminders.where((r) => reminderIds.contains(r.id) )){
      reminder.thingIds = [thingId, ...?reminder.thingIds];
      print(reminder.thingIds);
      await _fileManager.updateReminder(reminder);
    }

    getReminders();
  }

  Reminder? getById(String id) {
    try {
      return _reminders.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Reminder> getByThingId(String thingId){
    try{
      return _reminders.where((r) => r.thingIds != null && r.thingIds!.contains(thingId)).toList();
    }catch(e){
      return [];
    }
  }
}
