import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/providers/note_provider.dart';
import 'package:things_app/providers/reminder_provider.dart';

class ProviderHelper {

  void setAddReminderProviders(BuildContext context) {
    Provider.of<ReminderProvider>(context, listen: false).setSearchValue('');
  }

  void setAddThingProviders(BuildContext context){
    Provider.of<NotesProvider>(context, listen: false).reset();
  }
}