import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/providers/reminder_provider.dart';
import 'package:things_app/widgets/reminder_view.dart';

class RemindersListView extends StatelessWidget {
  const RemindersListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ReminderProvider>(
      builder: (context, reminderProvider, child) {
        return ListView.builder(
            itemCount: reminderProvider.reminders.length,
            itemBuilder: (ctx, index) {
              return ReminderView(
                reminder: reminderProvider.reminders[index],
              );
            });
      },
    );
  }
}
