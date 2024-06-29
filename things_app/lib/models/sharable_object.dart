import 'dart:convert';

import 'package:things_app/models/reminder.dart';
import 'package:things_app/models/thing.dart';

class ShareableThing {
  final String title;
  final Thing thing;
  final List<Reminder> reminders;

  ShareableThing({required this.thing, required this.reminders})
      : title = thing.title;
  ShareableThing.asJson({required this.title, required this.thing, required this.reminders});

  factory ShareableThing.fromMap(Map<String, dynamic> json) {
    return ShareableThing.asJson(
      title: json['title'],
      thing: Thing.fromJson(json['thing']),
      reminders: (json['reminders'] as List)
          .map((reminderJson) => Reminder.fromJson(reminderJson))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'thing': thing.toJson(),
      'reminders': reminders.map((reminder) => reminder.toJson()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory ShareableThing.fromJson(String source) =>
      ShareableThing.fromMap(json.decode(source));
}
