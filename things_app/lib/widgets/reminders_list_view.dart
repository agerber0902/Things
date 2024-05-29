import 'package:flutter/material.dart';
import 'package:things_app/models/reminder.dart';
import 'package:things_app/widgets/reminder_view.dart';

class RemindersListView extends StatelessWidget {
  const RemindersListView({
    super.key,
    required this.reminders, required this.deleteReminder, required this.addReminder, required this.editReminder,
  });

  final List<Reminder> reminders;
  final void Function(Reminder reminder) deleteReminder;
  final void Function(Reminder reminder) addReminder;
  final void Function(Reminder reminder) editReminder;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (ctx, index) {
          return ReminderView(reminder: reminders[index], deleteReminder: deleteReminder, addReminder: addReminder, editReminder: editReminder,);
        });
  }
}