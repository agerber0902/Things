import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/models/reminder.dart';
import 'package:things_app/models/thing_reminder.dart';
import 'package:things_app/providers/reminder_provider.dart';
import 'package:things_app/providers/thing_provider.dart';
import 'package:things_app/providers/thing_reminder_provider.dart';

class RemindersModal extends StatelessWidget {
  const RemindersModal({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Consumer3<ThingReminderProvider, ThingProvider, ReminderProvider>(
      builder: (context, thingReminderProvider, thingProvider, reminderProvider,
          child) {
        return AlertDialog(
          title: Text(
            thingProvider.activeThing != null &&
                    thingProvider.activeThing!.reminderIdsExist
                ? 'Edit Reminders'
                : 'Add Reminders',
            style:
                textTheme.displayMedium!.copyWith(color: colorScheme.primary),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  DropdownButton<String>(
                    hint: const Text('Select Reminders'),
                    value: null,
                    items: reminderProvider.reminders.map((reminder) {
                      return DropdownMenuItem<String>(
                        value: reminder.id,
                        child: Row(
                          children: [
                            Text(reminder.title),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      //TODO: If coming from add thing, we need to add a null thing

                      //On edit, add
                      if (thingProvider.activeThing != null) {}
                      //TODO: This covers both cases, if the active thing is null, it would mean its in add mode, and will get picked up in the add
                      //If active thing exists, its in edit mode and we can pass the active thing
                      thingReminderProvider.addThingReminder(ThingReminder(
                          thing: thingProvider.activeThing,
                          reminder: reminderProvider.getReminderById(value!)));
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SelectedReminders(
                  thingReminderProvider: thingReminderProvider,
                  selectedThingReminders: thingReminderProvider.thingReminders
                          ?.where((tr) => tr.reminder != null)
                          .toList() ??
                      [],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.onPrimaryContainer),
                    onPressed: () {
                      ThingProvider thingProvider =
                          Provider.of<ThingProvider>(context, listen: false);

                      if (thingProvider.activeThing != null) {
                        //TODO: Save thing with new reminders
                        thingProvider.setActiveThingReminders(
                            thingReminderProvider.getReminderIdsForThing(
                                thingProvider.activeThing!.id));

                        // //Save reminders
                        List<Reminder> remindersToEdit = Provider.of<
                                ThingReminderProvider>(context, listen: false)
                            .setRemindersForEdit(thingProvider.activeThing!.id);
                        ReminderProvider reminderProvider =
                            Provider.of<ReminderProvider>(context,
                                listen: false);
                        for (Reminder reminder in remindersToEdit) {
                          reminderProvider.editReminder(reminder);
                        }
                      }

                      Navigator.of(context).pop();
                    },
                    child: Text(
                      thingProvider.activeThing != null &&
                              thingProvider.activeThing!.reminderIdsExist
                          ? 'Edit'
                          : 'Add',
                      style: textTheme.bodyLarge!.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

class SelectedReminders extends StatefulWidget {
  const SelectedReminders({
    super.key,
    required List<ThingReminder> selectedThingReminders,
    required this.thingReminderProvider,
  }) : _selectedThingReminders = selectedThingReminders;

  final List<ThingReminder> _selectedThingReminders;
  final ThingReminderProvider thingReminderProvider;

  @override
  State<SelectedReminders> createState() => _SelectedRemindersState();
}

class _SelectedRemindersState extends State<SelectedReminders> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget._selectedThingReminders.map((tr) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            color: colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tr.reminder!.title,
                    style: textTheme.displaySmall!.copyWith(fontSize: 18),
                  ),
                  const SizedBox(width: 5),
                  Opacity(
                    opacity: 0.4,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        widget.thingReminderProvider.removeThingReminder(tr);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
