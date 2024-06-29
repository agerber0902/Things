import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/models/category.dart';
import 'package:things_app/models/thing.dart';
import 'package:things_app/providers/reminder_provider.dart';
import 'package:things_app/providers/thing_provider.dart';
import 'package:things_app/utils/icon_data.dart';

class ViewThingFromLink extends StatelessWidget {
  const ViewThingFromLink({super.key, required this.thing});

  final Thing thing;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      thing.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
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
                  children: thing.categories.map((category) {
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
                thing.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Visibility(
                    visible: thing.notesExist,
                    child: AppBarIcons().notesIcons.editNoteIcon,
                  ),
                  Visibility(
                    visible: thing.location != null,
                    child: AppBarIcons().locationIcons.containsLocationIcon,
                  ),
                  Visibility(
                    visible: thing.remindersExist,
                    child: AppBarIcons()
                        .thingReminderIcons
                        .containsThingRemindersIcon,
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                    onPressed: () {
                      final thingProvider =
                          Provider.of<ThingProvider>(context, listen: false);

                      //Create new thing to avoid duplicate thing ids
                      //This probably isnt needed, it will only cause issues if sharing things with yourself
                      //Thing thing = Thing(thingProvider.thingFromLink);

                      thingProvider.addThing(thingProvider.thingFromLink!);

                      Provider.of<ReminderProvider>(context, listen: false)
                          .addRemindersFromLink();

                      thingProvider.setThingFromLink(null);
                      Provider.of<ReminderProvider>(context, listen: false)
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
  }
}
