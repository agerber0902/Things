
import 'package:uuid/uuid.dart';

final uuid = const Uuid().v4();

class Reminder{
  final String id;
  final String? thingId;
  final String title;
  final String message;

  Reminder.forEdit({required this.id, this.thingId, required this.title, required this.message});
  Reminder.decoded({required this.id, required this.thingId, required this.title, required this.message,});
  Reminder({this.thingId, required this.title, required this.message}) : id = uuid;
}

class ReminderJsonHelper{
  List<Reminder> decodedReminders({required data}){
    List<Reminder> remindersToReturn = [];
    for (final MapEntry<String, dynamic> entry in data.entries) {
      remindersToReturn.add(decodedReminder(entry: entry));
    }

    return remindersToReturn;
  }

  Reminder decodedReminder({required entry}){
    final decodedReminder = Reminder.decoded(
          id: entry.key,
          title: entry.value['title'],
          message: entry.value['message'],
          thingId: entry.value['thingId'],
        );

    return decodedReminder;
  }

  Map<String, String?> reminderToMap({required Reminder reminder}){
    final encodedReminder = {
      'title': reminder.title,
      'message': reminder.message,
      'thingId': reminder.thingId,
    };
    return encodedReminder;
  }

}