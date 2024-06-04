import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final uuid = const Uuid().v4();

class Reminder {
  final String id;
  final String? thingId;
  final String title;
  final String message;
  final DateTime date;

  String get reminderDateToDisplay {
    return DateFormat.yMEd().add_jms().format(date.toLocal());
  }

  Reminder.forEdit({
    required this.id,
    this.thingId,
    required this.title,
    required this.message,
    required this.date,
  });
  Reminder.decoded({
    required this.id,
    required this.thingId,
    required this.title,
    required this.message,
    required this.date,
  });
  Reminder({
    this.thingId,
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
      thingId: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'date': date.toIso8601String(),
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
      thingId: entry.value['thingId'],
      date: DateFormat.yMEd().add_jms().parse(entry.value['date']),
    );

    return decodedReminder;
  }

  Map<String, String?> reminderToMap({required Reminder reminder}) {
    final encodedReminder = {
      'title': reminder.title,
      'message': reminder.message,
      'thingId': reminder.thingId,
      'date': DateFormat.yMEd().add_jms().format(reminder.date.toLocal()),
    };
    return encodedReminder;
  }
}
