import 'package:flutter/material.dart';
import 'package:things_app/helpers/file_manager.dart';
import 'package:things_app/models/thing.dart';

final ThingFileManager _fileManager = ThingFileManager();

class ThingsProvider extends ChangeNotifier{

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

  void removeCategory(Thing thing) async{
    
    //This will notify listeners
    getThings();
  }
}
