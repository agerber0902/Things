import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/models/reminder.dart';
import 'package:things_app/models/thing_reminder.dart';
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
            thingProvider.activeThing?.reminderIds != null
                ? 'Edit Reminders'
                : 'Add Reminders',
            style: textTheme.displaySmall!.copyWith(
                fontSize: textTheme.displaySmall!.fontSize! - 15.0,
                color: colorScheme.primary),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Container(
              alignment: Alignment.center,
              width: 300,
              height: 200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer<ReminderProvider>(
                    builder: (context, reminderProvider, child) {
                      reminderProvider.getReminders();
                      
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
                          onChanged: (value) {
                            thingReminderProvider.addThingReminder(
                                ThingReminder(
                                    reminder: value,
                                    thing: thingProvider.activeThing));
                          });
                    },
                  ),
                  const SizedBox(height: 16),

                  //Display Selected Reminders
                  Consumer<ThingReminderProvider>(
                    builder: (context, thingReminderProvider, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: thingReminderProvider.thingRemindersWithReminders
                            .map((thingReminder) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: colorScheme.primaryContainer,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(thingReminder.reminder!.title,
                                        style: textTheme.displaySmall!
                                            .copyWith(fontSize: 18)),
                                    const SizedBox(width: 10),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () => thingReminderProvider.deleteThingReminder(thingReminder),
                                      color: colorScheme.onPrimaryContainer
                                          .withOpacity(0.4),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.onPrimaryContainer),
                    onPressed: () {
                      //TODO: handle reminders
                      if(thingProvider.activeThing != null){
                        List<Reminder> remindersForThing = thingReminderProvider.getRemindersLinkedToThing(thingProvider.activeThing);

                        thingProvider.activeThing!.reminderIds = remindersForThing.map((r) => r.id).toList();
                        thingProvider.editThing(thingProvider.activeThing!);
                        print(thingProvider.activeThing!.reminderIds);
                      }
                      
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
          ),
        );
      },
    );
  }
}
