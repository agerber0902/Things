import 'package:flutter/material.dart';
import 'package:things_app/models/reminder.dart';
import 'package:things_app/models/thing.dart';
import 'package:things_app/models/thing_reminder.dart';

class ThingReminderProvider extends ChangeNotifier{
  List<ThingReminder>? _thingReminders;
  List<ThingReminder>? get thingReminders => _thingReminders;
  bool get thingRemindersExist => _thingReminders != null && _thingReminders!.isNotEmpty;

  void addThingReminder(ThingReminder tr){
    _thingReminders = [tr, ...?_thingReminders];
    print(_thingReminders);
    notifyListeners();
  }

  void setThingReminders(List<ThingReminder>? tr){
    _thingReminders = tr;
    print(_thingReminders);
    notifyListeners();
  }

  void setThingRemindersByObjects(Thing thing, Reminder reminder){
    _thingReminders = [ThingReminder(thing: thing, reminder: reminder) , ...?_thingReminders];
  }

  //Remove thing reminder from list 
  void removeThingReminder(ThingReminder thingReminder){
    _thingReminders?.remove(thingReminder);
    print(_thingReminders);
    notifyListeners();
  }

  // //Display these reminders in reminders modal
  // List<Reminder> remindersForDisplay(){
  //   return _thingReminders?.where((thingReminder) => thingReminder.reminder != null).map((r) => r.reminder!).toList() ?? [];
  // }

  // //Set the reminder ids for the thing we are adding or editing
  List<String>? getReminderIdsForThing(String thingId){
    return _thingReminders?.where((thingReminder) => thingReminder.thing != null && thingReminder.reminder != null && thingReminder.thing!.id == thingId).map((r) => r.reminder!.id).toList();
  }

  // //Get the list of reminders linked to the thing and use this list to update the reminders from thing screen
  // List<Reminder>? getRemindersFromThing(String thingId){
  //   return _thingReminders?.where((thingReminder) => thingReminder.thing != null && thingReminder.reminder != null && thingReminder.thing!.id == thingId).map((r) => r.reminder!).toList();
  // }

  // //Set list of reminders to edit
  // List<Reminder> setRemindersForEdit(String thingId){
  //   List<Reminder> remindersToEdit = getRemindersFromThing(thingId) ?? [];

  //   return remindersToEdit;
  // }

}