import 'package:flutter/material.dart';

class DeleteModal extends StatelessWidget {
  const DeleteModal(
      {super.key, required this.onDelete, required this.objectToDelete});

  final void Function(Object obj) onDelete;
  final Object objectToDelete;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(
        'Delete',
        style: textTheme.displayMedium!.copyWith(color: colorScheme.primary),
      ),
      content: Center(
        child: Column(
          children: [
            const Text('Are you sure you want to delete?'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.onPrimaryContainer),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.error),
                  onPressed: () {
                    onDelete(objectToDelete);
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
