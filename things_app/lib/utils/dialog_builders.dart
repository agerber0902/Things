import 'package:flutter/material.dart';
import 'package:things_app/widgets/reminders/add/add_reminders_modal.dart';

Future<void> remindersDialogBuilder(BuildContext context) {
  return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return const AddRemindersModal();
        });
      });
}
