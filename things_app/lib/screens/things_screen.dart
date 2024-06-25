import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/providers/thing_provider.dart';
import 'package:things_app/screens/categories_screen.dart';
import 'package:things_app/screens/reminders_screen.dart';
import 'package:things_app/utils/icon_data.dart';
import 'package:things_app/utils/things_setup.dart';
import 'package:things_app/widgets/filter_modal.dart';
import 'package:things_app/widgets/shared/appbar/shared_app_bar.dart';
import 'package:things_app/widgets/shared/appbar/shared_app_bar_button.dart';
import 'package:things_app/widgets/things/things_list_view.dart';

import 'package:things_app/helpers/file_manager.dart';

final ThingFileManager fileManager = ThingFileManager();

class ThingsScreen extends StatefulWidget {
  const ThingsScreen({super.key});

  @override
  State<ThingsScreen> createState() => _ThingsScreenState();
}

class _ThingsScreenState extends State<ThingsScreen> {

  @override
  void initState() {
    super.initState();

    //Check for things list and verify it exists. should exist unless its the first time on the screen.
    fileManager.verifyThingsList();

  }

  @override
  Widget build(BuildContext context) {

    final ThingsSetup setup = ThingsSetup();

    //Add filters to app bat
    setup.appBarSetup.appBarActions.insert(1, Consumer<ThingProvider>(builder:(context, thingProvider, child) {
      return SharedAppBarButton(
        icon: thingProvider.filterValues.isEmpty ? AppBarIcons().filterIcons.defaultFilterIcon : AppBarIcons().filterIcons.filterInUseIcon,
        isModal: true,
        displayWidget: const FilterDialog(),
      );
    },)); 

    //If things is empty, get things
    ThingProvider thingProvider = Provider.of<ThingProvider>(context, listen: false);
    if(thingProvider.things.isEmpty){
      thingProvider.getThings();
    }

    return Scaffold(
      appBar: SharedAppBar(
        title: setup.title,
        actions: setup.appBarSetup.appBarActions,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Center(
                child: Image.asset('assets/images/logo.png'),
              ),
            ),
            // ListTile(
            //   title: const Text('Categories'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.of(context).push(MaterialPageRoute(
            //         builder: (ctx) => const CategoriesScreen()));
            //   },
            // ),
            ListTile(
              title: const Text('Reminders'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const RemindersScreen()));
              },
            ),
            ListTile(
              title: const Text('Things'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return const ThingsScreen();
                }));
              },
            ),
          ],
        ),
      ),
      body: Consumer<ThingProvider>(
        builder: (context, thingProvider, child) {
          return thingProvider.things.isEmpty
              ? const NoThingsView()
              : const ThingsListView();
        },
      ),
    );
  }
}

class NoThingsView extends StatelessWidget {
  const NoThingsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No things!',
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: Colors.white,
                ),
          ),
          Text(
            'Add whatever you want!',
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(color: Colors.white.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }
}
