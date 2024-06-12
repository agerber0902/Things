import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/models/reminder.dart';
import 'package:things_app/providers/reminders_provider.dart';
import 'package:things_app/widgets/reminders/add/add_reminder.dart';
import 'package:things_app/widgets/reminders/no_reminders_view.dart';
import 'package:things_app/widgets/shared/appbar/shared_app_bar.dart';
import 'package:things_app/widgets/shared/appbar/shared_app_bar_add_button.dart';
import 'package:things_app/widgets/shared/shared_drawer.dart';
import 'package:things_app/widgets/shared/shared_list_view.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // State update that causes rebuilds
      final provider = Provider.of<RemindersProvider>(context, listen: false);
      provider.getReminders();
    });

    return Scaffold(
      appBar: const SharedAppBar(
        title: 'Reminders',
        actions: [
          SharedAppBarAddButton(
            modalBottomSheet: AddReminder(isFromModal: false,),
          ),
        ],
      ),
      drawer: const SharedDrawer(),
      body: Consumer<RemindersProvider>(
        builder: (context, provider, child) {
          return provider.reminders.isEmpty
              ? const NoRemindersView()
              : SharedListView<Reminder>(listItems: provider.reminders);
        },
      ),
    );
  }
}