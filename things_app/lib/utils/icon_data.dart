import 'package:flutter/material.dart';
import 'package:things_app/main.dart';

class AppBarIcons{

  FilterIcons filterIcons = FilterIcons();
  NotesIcons notesIcons = NotesIcons();
  LocationIcons locationIcons = LocationIcons();
  RemindersIcons remindersIcons = RemindersIcons();
  Icon addIcon = Icon(Icons.add, color: kColorScheme.primary,);

}

class FilterIcons{
  final Icon defaultFilterIcon = const Icon(Icons.filter_alt_outlined);
  final Icon filterInUseIcon = const Icon(Icons.filter_alt);
}

class NotesIcons{
  final Icon addNoteIcon = const Icon(Icons.note_add_outlined);
  final Icon editNoteIcon = const Icon(Icons.sticky_note_2);
}

class LocationIcons{
  final Icon addLocationIcon = const Icon(Icons.location_on_outlined);
  final Icon containsLocationIcon = const Icon(Icons.location_on, color: Colors.red);
}

class RemindersIcons{
  final Icon addRemindersIcon = const Icon(Icons.book_outlined);
  final Icon containsRemindersIcon = const Icon(Icons.book);
}