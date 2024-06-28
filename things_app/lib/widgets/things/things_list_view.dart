import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/models/category.dart';
import 'package:things_app/providers/reminder_provider.dart';
import 'package:things_app/providers/thing_provider.dart';
import 'package:things_app/utils/icon_data.dart';
import 'package:things_app/widgets/things/thing_view.dart';

class ThingsListView extends StatelessWidget {
  const ThingsListView({
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
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer),
                                onPressed: () {
                                  thingProvider
                                      .addThing(thingProvider.thingFromLink!);

                                  Provider.of<ReminderProvider>(context,
                                          listen: false)
                                      .addRemindersFromLink();

                                  thingProvider.setThingFromLink(null);
                                  Provider.of<ReminderProvider>(context,
                                          listen: false)
                                      .setRemindersFromLink(null);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Add',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
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

        return ListView.builder(
            itemCount: thingProvider.things.length,
            itemBuilder: (ctx, index) {
              return ThingView(thing: thingProvider.things[index]);
            });
      },
    );
  }
}
