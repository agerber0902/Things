import 'package:things_app/models/reminder.dart';
import 'package:things_app/models/thing.dart';

class ThingReminder{
  const ThingReminder({required this.reminder, required this.thing});

  final Reminder? reminder;
  final Thing? thing;
}