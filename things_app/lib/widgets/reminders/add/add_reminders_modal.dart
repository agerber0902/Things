// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:things_app/models/reminder.dart';
// import 'package:things_app/providers/reminders_provider.dart';
// import 'package:things_app/providers/thing_reminder_provider.dart';
// import 'package:things_app/providers/things_provider.dart';
// import 'package:things_app/widgets/reminders/add/add_reminder.dart';
// import 'package:things_app/widgets/shared/selected_reminder_view.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/models/reminder.dart';
import 'package:things_app/providers/reminders_provider.dart';
import 'package:things_app/providers/things_provider.dart';
import 'package:things_app/widgets/shared/selected_reminder_view.dart';

// ignore: must_be_immutable
class AddRemindersModal extends StatelessWidget {
  AddRemindersModal({super.key, this.triggerUpdate});

  bool? triggerUpdate;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    void onSave() {

      if(triggerUpdate != null){
        ThingsProvider provider = Provider.of<ThingsProvider>(context, listen: false);
        provider.thingInEdit!.reminderIds = provider.remindersForThing.map((r) => r.id).toList();
        provider.editThing(provider.thingInEdit!);
        RemindersProvider remindersProvider = Provider.of<RemindersProvider>(context, listen: false);
        remindersProvider.addThingIdToReminders(provider.remindersForThing, provider.thingInEdit!.id);
      }

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
                      builder: (context, reminderProvider, child) {
                        return DropdownButton<String>(
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
                            Reminder? reminder =
                                reminderProvider.getById(value!);
                            if (reminder == null) {
                              return;
                            }
                            final thingProvider =  Provider.of<ThingsProvider>(context, listen: false);
                            thingProvider.addReminderForThing(reminder);

                            Provider.of<RemindersProvider>(context, listen: false).addThingIdToReminders([reminder], thingProvider.thingInEdit!.id);
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
                    // TextButton(
                    //   onPressed: () {
                    //     showModalBottomSheet(
                    //         context: context,
                    //         isScrollControlled: true,
                    //         builder: (ctx) {
                    //           return const AddReminder(
                    //             isFromModal: true,
                    //           );
                    //         });
                    //   },
                    //   child: Text(
                    //     'Create New Reminder',
                    //     style: TextStyle(
                    //       color: colorScheme.primary,
                    //       decoration: TextDecoration.underline,
                    //     ),
                    //   ),
                    // ),
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
