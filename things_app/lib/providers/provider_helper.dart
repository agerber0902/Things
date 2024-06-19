import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/providers/category_provider.dart';
import 'package:things_app/providers/location_provider.dart';
import 'package:things_app/providers/note_provider.dart';
import 'package:things_app/providers/reminder_provider.dart';
import 'package:things_app/providers/thing_provider.dart';
import 'package:things_app/providers/thing_reminder_provider.dart';

class ProviderHelper {

  void setAddReminderProviders(BuildContext context) {
    Provider.of<ReminderProvider>(context, listen: false).setSearchValue('');
  }

  void setAddThingProviders(BuildContext context){
    Provider.of<ThingProvider>(context, listen: false).setActiveThing(null);
    Provider.of<NotesProvider>(context, listen: false).reset();
    Provider.of<CategoryProvider>(context, listen: false).reset();
    Provider.of<LocationProvider>(context, listen: false).setLocationForEdit(null);
    Provider.of<ThingReminderProvider>(context, listen: false).setThingReminders(null);
  }
}