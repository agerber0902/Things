import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/models/reminder.dart';
import 'package:things_app/models/thing.dart';
import 'package:things_app/models/thing_reminder.dart';
import 'package:things_app/providers/reminder_provider.dart';

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

  void setThingRemindersForActiveThing(Thing activeThing, List<Reminder> reminders){

    if(activeThing.reminderIds == null){
      _thingReminders = [];
    }
    else{
      _thingReminders = reminders.where((reminder) => activeThing.reminderIds != null && activeThing.reminderIds!.contains(reminder.id))
                                  .map((r) => ThingReminder(reminder: r, thing: activeThing)).toList();
    }

    notifyListeners();
    return;
  }

  List<Reminder> getRemindersLinkedToThing(Thing? thing){
    List<Reminder> remindersToLink = [];

    if(thing != null){
      remindersToLink = _thingReminders.where((tr) => (tr.thing != null && tr.thing!.id == thing!.id) && tr.reminder != null).map((r) => r.reminder!).toList();
    }
    else {
      remindersToLink = _thingReminders.where((tr) => tr.reminder != null).map((r) => r.reminder!).toList();
    }
    

    print(remindersToLink);

    return remindersToLink;
  }

}