import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:things_app/models/thing.dart';

const thingsListFileName = 'thingsList';

class FileManager {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _localFile(String fileName) async {
    final directoryPath = await _localPath;
    return File(path.join(directoryPath, '$fileName.json'));
  }

  Future<bool> get thingsListExists async {
    final file = await _localFile(thingsListFileName);
    return await file.exists();
  }

  void verifyThingsList() async{
    bool exists = await thingsListExists;
    if(!exists){
      final file = await _localFile(thingsListFileName);
      file.writeAsString('[]');
    }
  }

  Future<File> addThing(Thing thing) async {
    List<Thing> things = await readThingList();

    //Add thing to list of things
    things.add(thing);
    final file = await _localFile(thingsListFileName);
    return file.writeAsString(jsonEncode(things));

  }

  Future<File> updateThing(Thing thing) async {
    List<Thing> things = await readThingList();

    //Add thing to list of things
    int index = things.indexWhere((t) => t.id == thing.id);
    things[index] = thing;

    final file = await _localFile(thingsListFileName);
    
    return file.writeAsString(jsonEncode(things));

  }
  Future<File> deleteThing(Thing thing) async {
    List<Thing> things = await readThingList();

    things.removeWhere((t) => t.id == thing.id);

    final file = await _localFile(thingsListFileName);
    file.writeAsString(jsonEncode(things));
    
    return file.writeAsString(jsonEncode(things));

  }

  Future<File> saveObject(String fileName, Thing object) async {
    final file = await _localFile(fileName);
    return file.writeAsString(json.encode(object.toJson()));
  }

  Future<Thing?> readObject(String fileName) async {
    try {
      final file = await _localFile(fileName);
      if (await file.exists()) {
        final contents = await file.readAsString();
        return Thing.fromJson(json.decode(contents));
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<List<Thing>> readThingList() async {
    try {
      final file = await _localFile(thingsListFileName);
      if (await file.exists()) {
        final contents = await file.readAsString();
        
        //Return empty list
        if(contents == '[]'){
          return [];
        }

        //Parse List
        final decodedThings = jsonDecode(contents);

        List<Thing> things = [];
        for(Map<String, dynamic> thingMap in decodedThings){
          Thing thing = Thing.fromJson(thingMap);
          things.add(thing);
        }

        return things;
      }
    } catch (e) {
      return [];
    }
    return [];
  }

}
