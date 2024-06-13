import 'package:flutter/material.dart';
import 'package:things_app/widgets/reminders/add/add_reminders_modal.dart';
import 'package:things_app/widgets/things/add/add_thing_modal.dart';

Future<void> remindersThingsDialogBuilder(
    {required BuildContext context, required bool isReminder}) {
  return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return isReminder ? AddRemindersModal() : const AddThingModal();
        });
      });
}

void showThingModalBottomSheet(
    {required BuildContext context, required Widget bottomSheet}) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return bottomSheet;
      });
}


