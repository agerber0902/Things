import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:things_app/models/reminder.dart';
import 'package:things_app/models/thing.dart';

class FileManager {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _localFile(String fileName) async {
    final directoryPath = await _localPath;
    return File(path.join(directoryPath, '$fileName.json'));
  }
}

class ThingFileManager extends FileManager {
  final thingsListFileName = 'thingsList';

  Future<bool> get thingsListExists async {
    final file = await _localFile(thingsListFileName);
    return await file.exists();
  }

  void verifyThingsList() async {
    bool exists = await thingsListExists;
    if (!exists) {
      final file = await _localFile(thingsListFileName);
      file.writeAsString('[]');
    }
  }

  Future<List<Thing>> readThingList() async {
    try {
      final file = await _localFile(thingsListFileName);
      if (await file.exists()) {
        final contents = await file.readAsString();

        //Return empty list
        if (contents == '[]') {
          return [];
        }

        //Parse List
        final decodedThings = jsonDecode(contents);

        List<Thing> things = [];
        for (Map<String, dynamic> thingMap in decodedThings) {
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

  Future<List<Thing>> readThingListByIds(List<String> ids) async {
    try {
        List<Thing> things = await readThingList();

        return things.where((t) => ids.contains(t.id)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Thing?> readThingById(String id) async {
    try {
        List<Thing> things = await readThingList();

        return things.firstWhere((t) => id == t.id);
    } catch (e) {
      return null;
    }
  }

  Future<File> deleteThing(Thing thing) async {
    List<Thing> things = await readThingList();

    things.removeWhere((t) => t.id == thing.id);

    final file = await _localFile(thingsListFileName);
    file.writeAsString(jsonEncode(things));

    return file.writeAsString(jsonEncode(things));
  }

  Future<File> addThing(Thing thing) async {
    List<Thing> things = await readThingList();

    //Add thing to list of things
    things.add(thing);
    final file = await _localFile(thingsListFileName);
    // Convert the list of objects to a list of JSON maps
    List<Map<String, dynamic>> jsonList =
        things.map((thing) => thing.toJson()).toList();

    // Encode the list of JSON maps to a JSON string
    String jsonString = jsonEncode(jsonList);

    return file.writeAsString(jsonString);
  }

  Future<File> updateThing(Thing thing) async {
    List<Thing> things = await readThingList();

    //Add thing to list of things
    int index = things.indexWhere((t) => t.id == thing.id);
    things[index] = thing;

    final file = await _localFile(thingsListFileName);

    return file.writeAsString(jsonEncode(things));
  }
}

class ReminderFileManager extends FileManager {
  final remindersListFileName = 'remindersList';

  Future<bool> get remindersListExists async {
    final file = await _localFile(remindersListFileName);
    return await file.exists();
  }

  void verifyRemindersList() async {
    bool exists = await remindersListExists;
    if (!exists) {
      final file = await _localFile(remindersListFileName);
      file.writeAsString('[]');
    }
  }

  Future<List<Reminder>> readReminderList() async {
    try {
      final file = await _localFile(remindersListFileName);
      if (await file.exists()) {
        final contents = await file.readAsString();

        //Return empty list
        if (contents == '[]') {
          return [];
        }

        //Parse List
        final decodedReminders = jsonDecode(contents);

        List<Reminder> reminders = [];
        for (Map<String, dynamic> reminderMap in decodedReminders) {
          Reminder reminder = Reminder.fromJson(reminderMap);
          reminders.add(reminder);
        }

        return reminders;
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  Future<File> deleteReminder(Reminder reminder) async {
    List<Reminder> reminders = await readReminderList();

    reminders.removeWhere((t) => t.id == reminder.id);

    final file = await _localFile(remindersListFileName);
    file.writeAsString(jsonEncode(reminders));

    return file.writeAsString(jsonEncode(reminders));
  }

  Future<File> addReminder(Reminder reminder) async {
    List<Reminder> reminders = await readReminderList();

    //Add Reminder to list of Reminders
    reminders.add(reminder);
    final file = await _localFile(remindersListFileName);

    // Convert the list of objects to a list of JSON maps
    List<Map<String, dynamic>> jsonList =
        reminders.map((reminder) => reminder.toJson()).toList();

    // Encode the list of JSON maps to a JSON string
    String jsonString = jsonEncode(jsonList);

    return file.writeAsString(jsonString);
  }

  Future<File> updateReminder(Reminder reminder) async {
    List<Reminder> reminders = await readReminderList();

    //Add Reminder to list of Reminders
    int index = reminders.indexWhere((t) => t.id == reminder.id);
    reminders[index] = reminder;

    final file = await _localFile(remindersListFileName);

    return file.writeAsString(jsonEncode(reminders));
  }
}
