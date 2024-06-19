import 'package:things_app/models/reminder.dart';
import 'package:things_app/models/thing.dart';

class ThingReminder{
  final Thing? thing;
  final Reminder? reminder;

  ThingReminder({required this.thing, required this.reminder});

  factory ThingReminder.fromJson(Map<String, dynamic> json) {
    return ThingReminder(
      thing: json['thing'] != null ? Thing.fromJson(json['thing']) : null,
      reminder: json['reminder'] != null ? Reminder.fromJson(json['reminder']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'thing': thing?.toJson(),
      'reminder': reminder?.toJson(),
    };
  }
}