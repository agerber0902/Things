import 'package:flutter/material.dart';
import 'package:things_app/models/reminder.dart';
import 'package:things_app/utils/icon_data.dart';
import 'package:things_app/widgets/add_reminder.dart';
import 'package:things_app/widgets/shared/appbar/search_bar.dart';
import 'package:things_app/widgets/shared/appbar/shared_app_bar_button.dart';

const double _seachActiveWidth = 250;

class RemindersSetup {

  //Title in the app bar at the top of the screen
  final String title = 'Reminders';

  final AppBarSetup appBarSetup = AppBarSetup(
    //Flag to display search
    displaySearch: true,
    //Width when search is expanded
    searchActiveWidth: _seachActiveWidth,
    //Action buttons listed on the appbar
    appBarActions: [

      //Add Search
      const CollapsableSearchBar(isThingSearch: false, expandedWidth: _seachActiveWidth),

      //Reminder does not use filters

      //Add Button
      //TODO: remove add reminder params
      SharedAppBarButton(
        icon: AppBarIcons().addIcon,
        displayWidget: AddReminder(
          addReminder: (Reminder reminder) {},
          editReminder: (Reminder reminder) {},
          availableThings: [],
        ),
      )
    ],
  );
  //Action buttons listed on the appbar
  final List<Widget> appBarActions = [];
}

class AppBarSetup {
  const AppBarSetup(
      {required this.displaySearch,
      required this.searchActiveWidth,
      required this.appBarActions});

  final List<Widget> appBarActions;
  final bool displaySearch;
  final double searchActiveWidth;
}
