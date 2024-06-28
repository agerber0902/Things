import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/models/category.dart';
import 'package:things_app/providers/reminder_provider.dart';
import 'package:things_app/providers/thing_provider.dart';
import 'package:things_app/screens/reminders_screen.dart';
import 'package:things_app/utils/icon_data.dart';
import 'package:things_app/utils/things_setup.dart';
import 'package:things_app/widgets/filter_modal.dart';
import 'package:things_app/widgets/shared/appbar/shared_app_bar.dart';
import 'package:things_app/widgets/shared/appbar/shared_app_bar_button.dart';
import 'package:things_app/widgets/things/thing_view.dart';
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
    // Check for things list and verify it exists. Should exist unless it's the first time on the screen.
    fileManager.verifyThingsList();
  }

  @override
  Widget build(BuildContext context) {
    final ThingsSetup setup = ThingsSetup();

    // Add filters to app bar
    setup.appBarSetup.appBarActions.insert(1, Consumer<ThingProvider>(
      builder: (context, thingProvider, child) {
        return SharedAppBarButton(
          icon: thingProvider.filterValues.isEmpty
              ? AppBarIcons().filterIcons.defaultFilterIcon
              : AppBarIcons().filterIcons.filterInUseIcon,
          isModal: true,
          displayWidget: const FilterDialog(),
        );
      },
    ));

    // If things is empty, get things
    ThingProvider thingProvider =
        Provider.of<ThingProvider>(context, listen: false);
    if (thingProvider.things.isEmpty) {
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
    return Consumer<ThingProvider>(
      builder: (context, thingProvider, child) {
        if (thingProvider.thingFromLink != null) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            // Show your dialog here
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  insetPadding: EdgeInsets.all(20),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  thingProvider.thingFromLink!.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .fontSize!,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: thingProvider.thingFromLink!.categories
                                  .map((category) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Icon(
                                    categoryIcons[category]!.iconData,
                                    color: categoryIcons[category]!.iconColor,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            thingProvider.thingFromLink!.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Visibility(
                                visible:
                                    thingProvider.thingFromLink!.notesExist,
                                child: AppBarIcons().notesIcons.editNoteIcon,
                              ),
                              Visibility(
                                visible:
                                    thingProvider.thingFromLink!.location !=
                                        null,
                                child: AppBarIcons()
                                    .locationIcons
                                    .containsLocationIcon,
                              ),
                              Visibility(
                                visible:
                                    thingProvider.thingFromLink!.remindersExist,
                                child: AppBarIcons()
                                    .thingReminderIcons
                                    .containsThingRemindersIcon,
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.onPrimaryContainer),
                              onPressed: (){
                                thingProvider.addThing(thingProvider.thingFromLink!);

                                Provider.of<ReminderProvider>(context, listen: false).addRemindersFromLink();

                                thingProvider.setThingFromLink(null);
                                Provider.of<ReminderProvider>(context, listen: false).setRemindersFromLink(null);
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                 'Add',
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                            ],
                            
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          });
        }

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
      },
    );
  }
}
