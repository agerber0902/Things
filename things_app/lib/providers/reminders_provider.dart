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

  void addThingIdToReminders(List<Reminder> remindersToEdit, String thingId) async{

    List<String> remindersToEditIds = remindersToEdit.map((r) => r.id).toList();

    for(Reminder reminder in reminders.where((r) => remindersToEditIds.contains(r.id) )){
      reminder.thingIds = [thingId, ...?reminder.thingIds?.where((t) => t != thingId)];
      await _fileManager.updateReminder(reminder);
    }

    getReminders();
  }

  void removeThingIdToReminders(List<Reminder> remindersToEdit, String thingId) async{

    List<String> remindersToEditIds = remindersToEdit.map((r) => r.id).toList();

    for(Reminder reminder in reminders.where((r) => remindersToEditIds.contains(r.id) )){
      reminder.thingIds?.remove(thingId);
      await _fileManager.updateReminder(reminder);
    }

    getReminders();
  }

  Reminder? getById(String id) {
    try {
      return reminders.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Reminder> _thingReminders = [];
  List<Reminder> get thingReminders => _thingReminders;

  void getThingReminders(String thingId){
    try{
      _thingReminders = reminders.where((r) => r.thingIds != null && r.thingIds!.contains(thingId)).toList();
    }catch(e){
      return;
    }
  }
}
