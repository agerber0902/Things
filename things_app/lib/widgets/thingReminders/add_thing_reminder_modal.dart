import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/models/reminder.dart';
import 'package:things_app/providers/reminder_provider.dart';
import 'package:things_app/providers/thing_provider.dart';
import 'package:things_app/providers/thing_reminder_provider.dart';

class AddThingReminderModal extends StatelessWidget {
  const AddThingReminderModal({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer2<ThingReminderProvider, ThingProvider>(
      builder: (context, thingReminderProvider, thingProvider, child) {
        return AlertDialog(
          title: Text(
            thingProvider.activeThing?.location != null
                ? 'Edit Reminders'
                : 'Add Reminders',
            style: textTheme.displaySmall!.copyWith(
                fontSize: textTheme.displaySmall!.fontSize! - 15.0,
                color: colorScheme.primary),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer<ReminderProvider>(
                  builder: (context, reminderProvider, child) {
                    return DropdownButton(
                        //TODO: style the text
                        hint: const Text('Select Reminders'),
                        items: reminderProvider.reminders.map((reminder) {
                          return DropdownMenuItem<Reminder>(
                            value: reminder,
                            child: Row(
                              children: [
                                Text(reminder.title),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {});
                  },
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.onPrimaryContainer),
                  onPressed: () {
                    //TODO:
                    //thingReminderProvider.
                    
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Add',
                    style: textTheme.bodyLarge!.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
