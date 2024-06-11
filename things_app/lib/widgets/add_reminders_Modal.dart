import 'package:flutter/material.dart';
import 'package:things_app/widgets/add_reminder.dart';

class AddRemindersModal extends StatelessWidget {
  const AddRemindersModal({super.key, required this.createReminderBottomSheet});

  final Widget createReminderBottomSheet;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(
        'Add Reminders',
        style: textTheme.displayMedium!.copyWith(color: colorScheme.primary),
      ),
      content: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (ctx) {
                      return createReminderBottomSheet;
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
              onPressed: () {},
              child: Text(
                'Save',
                style: textTheme.bodyLarge!.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
