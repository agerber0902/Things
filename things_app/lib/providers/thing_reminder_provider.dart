import 'package:flutter/material.dart';
import 'package:things_app/models/thing_reminder.dart';

class ThingReminderProvider extends ChangeNotifier{
  ThingReminder? _thingReminder;
  ThingReminder? get thingReminder => _thingReminder;

  void setThingReminder(ThingReminder? tr){
    _thingReminder = tr;
    notifyListeners();
  }
}