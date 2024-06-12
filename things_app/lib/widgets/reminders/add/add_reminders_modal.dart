import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/models/reminder.dart';
import 'package:things_app/providers/reminders_provider.dart';
import 'package:things_app/providers/thing_reminder_provider.dart';
import 'package:things_app/widgets/reminders/add/add_reminder.dart';
import 'package:things_app/widgets/shared/selected_reminder_view.dart';

class AddRemindersModal extends StatelessWidget {
  const AddRemindersModal({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    Provider.of<RemindersProvider>(context, listen: false).getReminders();

    void onSave() {
      Navigator.of(context).pop();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return AlertDialog(
          title: Text(
            'Add Reminders',
            style:
                textTheme.displayMedium!.copyWith(color: colorScheme.primary),
          ),
          content: SizedBox(
            width: constraints.maxWidth,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Consumer<RemindersProvider>(
                      builder: (context, provider, child) {
                        return DropdownButton<String>(
                          hint: const Text('Select Reminders'),
                          value: null,
                          items: provider.reminders.map((reminder) {
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
                            Reminder? reminder = provider.getById(value!);
                            if (reminder == null) {
                              return;
                            }
                            Provider.of<ThingReminderProvider>(context,
                                    listen: false)
                                .add(ThingReminder.withReminder(
                                    reminder: reminder));
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    const SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SelectedReminderView(),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (ctx) {
                              return const AddReminder(
                                isFromModal: true,
                              );
                            });
                      },
                      child: Text(
                        'Create New Reminder',
                        style: TextStyle(
                          color: colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.onPrimaryContainer),
                      onPressed: onSave,
                      child: Text(
                        'Save',
                        style:
                            textTheme.bodyLarge!.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
