import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/providers/category_provider.dart';
import 'package:things_app/providers/notes_provider.dart';
import 'package:things_app/providers/things_provider.dart';

class ProviderHelper {
  void setAddThingProviders(BuildContext context) {
    Provider.of<ThingsProvider>(context, listen: false).setThingInEdit(null);
    Provider.of<ThingsProvider>(context, listen: false).resetRemindersForThing();
    Provider.of<NotesProvider>(context, listen: false).reset();
    Provider.of<CategoryProvider>(context, listen: false).reset();
  }
}
