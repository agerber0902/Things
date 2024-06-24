import 'package:flutter/material.dart';
import 'package:things_app/models/reminder.dart';
import 'package:things_app/models/thing.dart';
import 'package:things_app/models/thing_reminder.dart';

class ThingReminderProvider extends ChangeNotifier{

  List<ThingReminder> _thingReminders = [];
  List<ThingReminder> get thingReminders => _thingReminders;

  List<ThingReminder> get thingRemindersWithReminders => thingReminders.where((tr) => tr.reminder != null).toList();

  void setThingReminders(List<ThingReminder> thingRemindersToSet){
    _thingReminders = thingRemindersToSet;
    notifyListeners();
  }

  void addThingReminder(ThingReminder thingReminder){
    _thingReminders.add(thingReminder);
    print(_thingReminders);
    notifyListeners();
  }
  void deleteThingReminder(ThingReminder thingReminder){
    _thingReminders.remove(thingReminder);
    print(_thingReminders);
    notifyListeners();
  }

  void setRemindersLinkedToThing(Thing? thing){
    //TODO: if empty, remove thingReminders
    List<Reminder> remindersToLink = [];

    remindersToLink = _thingReminders.where((tr) => tr.reminder != null).map((r) => r.reminder!).toList();

    //TODO:
    if(thing != null){}

    print(remindersToLink);

    //TODO: do we need this?
    notifyListeners();
  }

}