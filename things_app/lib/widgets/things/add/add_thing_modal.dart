import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/models/thing.dart';
import 'package:things_app/providers/thing_reminder_provider.dart';
import 'package:things_app/providers/things_provider.dart';
import 'package:things_app/widgets/shared/selected_thing_view.dart';
import 'package:things_app/widgets/things/add/add_thing.dart';

class AddThingModal extends StatelessWidget {
  const AddThingModal({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    Provider.of<ThingsProvider>(context, listen: false).getThings();

    void onSave() {
      Navigator.of(context).pop();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return AlertDialog(
          title: Text(
            'Add Things',
            style:
                textTheme.displayMedium!.copyWith(color: colorScheme.primary),
          ),
          content: SizedBox(
            width: constraints.maxWidth,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Consumer<ThingsProvider>(
                      builder: (context, provider, child) {
                        return DropdownButton<String>(
                          hint: const Text('Select Things'),
                          value: null,
                          items: provider.things.map((thing) {
                            return DropdownMenuItem<String>(
                              value: thing.id,
                              child: Row(
                                children: [
                                  Text(thing.title),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            Thing? thing = provider.getById(value!);
                            if (thing == null) {
                              return;
                            }
                            Provider.of<ThingReminderProvider>(context,
                                    listen: false)
                                .add(ThingReminder.withThing(
                                    thing: thing));
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    const SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SelectedThingView(),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (ctx) {
                              return const AddThing(
                                //isFromModal: true,
                              );
                            });
                      },
                      child: Text(
                        'Create New Thing',
                        style: TextStyle(
                          color: colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.onPrimaryContainer),
                      onPressed: onSave,
                      child: Text(
                        'Save',
                        style:
                            textTheme.bodyLarge!.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
