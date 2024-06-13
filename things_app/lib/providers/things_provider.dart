import 'package:flutter/material.dart';
import 'package:things_app/helpers/file_manager.dart';
import 'package:things_app/models/reminder.dart';
import 'package:things_app/models/thing.dart';

final ThingFileManager _fileManager = ThingFileManager();

class ThingsProvider extends ChangeNotifier{

  //Thing that should be used when in edit mode
  Thing? _thingInEdit;
  Thing? get thingInEdit => _thingInEdit;
  bool get isEditMode => thingInEdit != null;
  void setThingInEdit(Thing? thing){
    _thingInEdit = thing;
    notifyListeners();
  }

  List<Thing> _things = [];
  List<Thing> get things => _things;

  //Get the list of things
  void getThings() async{
    _things = await _fileManager.readThingList();
    
    notifyListeners();
  }

  //Add Thing to List
  void addThing(Thing thing) async{

    await _fileManager.addThing(thing);

    //This will notify listeners
    getThings();
  }

  //Delete Thing from List
  void deleteThing(Thing thing) async{

    //Remove from the list of things first to avoid widget tree error
    _things.remove(thing);

    await _fileManager.deleteThing(thing);

    //This will notify listeners
    getThings();
  }

  //Edit Thing from List
  void editThing(Thing thing) async{
    await _fileManager.updateThing(thing);

    //This will notify listeners
    getThings();
  }

  List<Reminder> _remindersForThing = [];
  List<Reminder> get remindersForThing => _remindersForThing;

  void addReminderForThing(Reminder reminder){
    _remindersForThing = [reminder, ..._remindersForThing];
    notifyListeners();
  }
  void deleteReminderForThing(Reminder reminder){
    _remindersForThing.remove(reminder);
    notifyListeners();
  }
  void resetRemindersForThing(){
    _remindersForThing = [];
    notifyListeners();
  }
  void setRemindersForThing(List<Reminder> reminders){
    _remindersForThing = reminders;
    notifyListeners();
  }

  Thing? getById(String id) {
    try {
      return _things.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }
}
