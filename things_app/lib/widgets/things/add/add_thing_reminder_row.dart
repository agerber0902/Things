import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/providers/things_provider.dart';
import 'package:things_app/utils/dialog_builders.dart';
import 'package:things_app/utils/icon_data.dart';

class AddThingReminderRow extends StatelessWidget {
  const AddThingReminderRow({super.key});

  @override
  Widget build(BuildContext context) {
    //final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Consumer<ThingsProvider>(
      builder: (context, thingProvider, child) {
        bool hasReminders = thingProvider.remindersForThing.isNotEmpty;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () {
                remindersThingsDialogBuilder(
                    context: context, isReminder: true);
              },
              label: Text(
                hasReminders ? 'Edit Reminders' : 'Add Reminders',
                style: TextStyle(
                  color: colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
              icon: 
                  hasReminders ? containsRemindersIcon : emptyReminderIcon,
            ),
          ],
        );
      },
    );
  }
}
