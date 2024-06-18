import 'package:things_app/models/reminder.dart';
import 'package:things_app/models/thing.dart';

class ThingReminder{
  final Thing thing;
  final Reminder reminder;

  ThingReminder({required this.thing, required this.reminder});

  factory ThingReminder.fromJson(Map<String, dynamic> json) {
    return ThingReminder(
      thing: Thing.fromJson(json['thing']),
      reminder: Reminder.fromJson(json['reminder']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'thing': thing.toJson(),
      'reminder': reminder.toJson(),
    };
  }
}