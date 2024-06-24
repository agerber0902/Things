import 'package:flutter/material.dart';
import 'package:things_app/models/thing_reminder.dart';

class ThingReminderProvider extends ChangeNotifier{

  List<ThingReminder>? _thingReminders;
  List<ThingReminder>? get thingReminders => _thingReminders;

  void setThingReminders(List<ThingReminder>? thingRemindersToSet){
    _thingReminders = thingRemindersToSet;
    notifyListeners();
  }

}