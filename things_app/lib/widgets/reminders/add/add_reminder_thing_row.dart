import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/providers/thing_reminder_provider.dart';
import 'package:things_app/utils/dialog_builders.dart';
import 'package:things_app/utils/icon_data.dart';

class AddReminderThingRow extends StatelessWidget {
  const AddReminderThingRow({super.key});

  @override
  Widget build(BuildContext context) {
    //final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Consumer<ThingReminderProvider>(
      builder: (context, provider, child) {
        List<ThingReminder> thingReminders = provider.thingRemindersWithReminders;
        bool hasReminders = thingReminders.isNotEmpty;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () {
                remindersThingsDialogBuilder(context : context, isReminder: false);
              },
              label: Text(
                hasReminders ? 'Edit Things' : 'Add Things',
                style: TextStyle(
                  color: colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
              icon: Icon(hasReminders ? containsRemindersIcon : emptyReminderIcon),
            ),
          ],
        );
      },
    );
  }
}
