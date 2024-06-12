import 'package:flutter/material.dart';
import 'package:things_app/models/reminder.dart';
import 'package:things_app/models/thing.dart';

class ThingReminderProvider extends ChangeNotifier{

  List<ThingReminder>? _thingReminders;
  List<ThingReminder>? get thingReminders => _thingReminders;
  bool get thingRemindersExist => thingReminders != null && thingReminders!.isNotEmpty;
  List<ThingReminder> get thingRemindersWithThings => thingRemindersExist ? _thingReminders!.where((tr) => tr.thing != null).toList() : [];
  List<ThingReminder> get thingRemindersWithReminders => thingRemindersExist ? _thingReminders!.where((tr) => tr.reminder != null).toList() : [];
  List<ThingReminder> get thingRemindersWithBoth => thingRemindersExist ? _thingReminders!.where((tr) => tr.thing != null && tr.reminder != null).toList() : [];

  void reset() {
    _thingReminders = null;
    notifyListeners();
  }

  void add(ThingReminder thingReminder){
    _thingReminders = [thingReminder, ...?_thingReminders];
    notifyListeners();
  }
  void delete(ThingReminder thingReminder){
    _thingReminders?.remove(thingReminder);
    notifyListeners();
  }
  void edit(ThingReminder thingReminder, int index){
    _thingReminders?[index] = thingReminder;
    notifyListeners();
  }

  Reminder? _newReminder;
  Reminder? get newReminder => _newReminder;

  void createReminder(Reminder reminder){
    //Create Reminder
    _newReminder = reminder;

    //Create Thing Reminder with no thing
    ThingReminder.withReminder(reminder: reminder);

    notifyListeners();
  }

  Thing? _newThing;
  Thing? get newThing => _newThing;

  void createThing(Thing thing){
    //Create Thing
    _newThing = thing;

    //Create Thing Thing with no thing
    ThingReminder.withThing(thing: thing);

    notifyListeners();
  }

}

class ThingReminder{
  Thing? thing;
  Reminder? reminder;

  ThingReminder({required this.thing, required this.reminder});
  ThingReminder.withReminder({required this.reminder});
  ThingReminder.withThing({required this.thing});
}