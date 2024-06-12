import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final uuid = const Uuid().v4();

class Reminder {
  final String id;
  List<String>? thingIds;
  final String title;
  final String message;
  final DateTime date;

  String get reminderDateToDisplay {
    return DateFormat.yMEd().add_jms().format(date.toLocal());
  }

  Reminder.forEdit({
    required this.id,
    this.thingIds,
    required this.title,
    required this.message,
    required this.date,
  });
  Reminder.create(
      {this.thingIds,
      required this.title,
      required this.message,
      required this.date})
      : id = const Uuid().v4();
      
  Reminder.decoded({
    required this.id,
    required this.thingIds,
    required this.title,
    required this.message,
    required this.date,
  });
  Reminder({
    this.thingIds,
    required this.title,
    required this.message,
    required this.date,
  }) : id = const Uuid().v4();

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder.decoded(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      date: DateTime.parse(json['date']),
      thingIds:
          json['thingIds'] != null ? List<String>.from(json['thingIds']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'date': date.toIso8601String(),
      'thingsIds': thingIds,
    };
  }
}

class ReminderJsonHelper {
  List<Reminder> decodedReminders({required data}) {
    List<Reminder> remindersToReturn = [];
    for (final MapEntry<String, dynamic> entry in data.entries) {
      remindersToReturn.add(decodedReminder(entry: entry));
    }

    return remindersToReturn;
  }

  Reminder decodedReminder({required entry}) {
    final decodedReminder = Reminder.decoded(
      id: entry.key,
      title: entry.value['title'],
      message: entry.value['message'],
      thingIds: entry.value['thingIds'].split(','),
      date: DateFormat.yMEd().add_jms().parse(entry.value['date']),
    );

    return decodedReminder;
  }

  Map<String, String?> reminderToMap({required Reminder reminder}) {
    final encodedReminder = {
      'title': reminder.title,
      'message': reminder.message,
      'thingIds': reminder.thingIds?.join(','),
      'date': DateFormat.yMEd().add_jms().format(reminder.date.toLocal()),
    };
    return encodedReminder;
  }
}
