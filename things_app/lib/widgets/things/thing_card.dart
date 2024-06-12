import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/models/category.dart';
import 'package:things_app/models/thing.dart';
import 'package:things_app/providers/reminders_provider.dart';
import 'package:things_app/providers/things_provider.dart';
import 'package:things_app/utils/dialog_builders.dart';
import 'package:things_app/utils/icon_data.dart';
import 'package:things_app/widgets/notes/notes_modal.dart';

class ThingCard extends StatelessWidget {
  const ThingCard({super.key, required this.thing});

  final Thing thing;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Consumer<ThingsProvider>(
      builder: (context, provider, child) {
        Future<void> notesDialogBuilder(BuildContext context) {
          return showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return NotesModal(
                    title: thing.title,
                    notes: thing.notes,
                    onAdd: (notes) {
                      thing.notes = notes;
                      provider.editThing(thing);
                    },
                    onEdit: (notes) {
                      thing.notes = notes;
                      provider.editThing(thing);
                    },
                  );
                });
              });
        }

        return Card(
          color: colorScheme.primaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Favorite Icon Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        thing.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.displaySmall!.copyWith(
                          fontSize: textTheme.displaySmall!.fontSize! - 5.0,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (thing.categoriesContainsFavorite) {
                          thing.categories.remove('favorite');
                        } else {
                          thing.categories.add('favorite');
                        }
                        provider.editThing(thing);
                      },
                      icon: Icon(
                        thing.categoriesContainsFavorite
                            ? categoryIcons['favorite']!.iconData
                            : Icons.favorite_outline,
                        color: thing.categoriesContainsFavorite
                            ? categoryIcons['favorite']!.iconColor
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Categories Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: thing.categories
                        .where((c) => c != 'favorite')
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
                // Description
                Text(
                  thing.description ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                // Notes and Complete Icons Row
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            notesDialogBuilder(context);
                          },
                          child: thing.notes == null || thing.notes!.isEmpty
                              ? const Icon(Icons.note_add_outlined)
                              : const Icon(Icons.sticky_note_2),
                        ),
                        Consumer2<ThingsProvider, RemindersProvider>(
                          builder: (context, thingsProvider, reminderProvider,
                              child) {
                            return GestureDetector(
                              onTap: () {
                                remindersDialogBuilder(context);
                              },
                              child: reminderProvider
                                      .getByThingId(thing.id)
                                      .isEmpty
                                  ? const Icon(emptyReminderIcon)
                                  : const Icon(containsRemindersIcon),
                            );
                          },
                        )
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        thing.isMarkedComplete = !thing.isMarkedComplete;
                        provider.editThing(thing);
                      },
                      icon: Icon(
                        Icons.check_box,
                        color: thing.isMarkedComplete
                            ? Colors.green
                            : colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
