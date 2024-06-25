import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/models/category.dart';
import 'package:things_app/models/thing.dart';
import 'package:things_app/providers/category_provider.dart';
import 'package:things_app/providers/location_provider.dart';
import 'package:things_app/providers/note_provider.dart';
import 'package:things_app/providers/reminder_provider.dart';
import 'package:things_app/providers/thing_provider.dart';
import 'package:things_app/providers/thing_reminder_provider.dart';
import 'package:things_app/utils/icon_data.dart';
import 'package:things_app/widgets/location/location_modal.dart';
import 'package:things_app/widgets/notes_modal.dart';
import 'package:things_app/widgets/thingReminders/add_thing_reminder_modal.dart';
import 'package:things_app/widgets/things/add_thing.dart';

const double initHeight = 200;

class ThingView extends StatefulWidget {
  const ThingView({super.key, required this.thing});

  final Thing thing;

  @override
  State<ThingView> createState() => _ThingViewState();
}

class _ThingViewState extends State<ThingView> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<ThingProvider>(
      builder: (context, thingProvider, child) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Opacity(
              opacity: _animation.value,
              child: Dismissible(
                key: Key(widget.thing.id),
                onDismissed: (direction) {
                  final thing = widget.thing;
                  thingProvider.deleteThing(widget.thing);

                  ScaffoldMessenger.of(context)
                    ..clearSnackBars()
                    ..showSnackBar(SnackBar(
                      content: Text(
                        "${thing.title} was deleted.",
                        style: textTheme.bodyLarge!
                            .copyWith(color: colorScheme.onPrimary),
                      ),
                      action: SnackBarAction(
                        label: "Undo",
                        onPressed: () {
                          thingProvider.addThing(thing);
                        },
                      ),
                    ));
                },
                child: SizedBox(
                  height: initHeight,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ThingCard(thing: widget.thing),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ThingCard extends StatefulWidget {
  const ThingCard({super.key, required this.thing});

  final Thing thing;

  @override
  State<ThingCard> createState() => _ThingCardState();
}

class _ThingCardState extends State<ThingCard> {
  bool? _isFavorite;
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.thing.categoriesContainsFavorite;
    _isCompleted = widget.thing.isMarkedComplete;
  }

  Future<void> _showNotesDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return NotesModal(
              title: widget.thing.title,
              notes: widget.thing.notes,
              isTriggerAdd: true,
            );
          },
        );
      },
    );
  }

  Future<void> _showLocationDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return const LocationModal();
          },
        );
      },
    );
  }

  Future<void> _showThingReminderDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return const AddThingReminderModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<ThingProvider>(
      builder: (context, thingProvider, child) {
        return GestureDetector(
          onTap: () {
            thingProvider.setActiveThing(widget.thing);
            Provider.of<CategoryProvider>(context, listen: false)
                .setCategoriesForEdit(thingProvider.activeThing!.categories);
            Provider.of<NotesProvider>(context, listen: false)
                .setNotesForEdit(thingProvider.activeThing!.notes);
            Provider.of<LocationProvider>(context, listen: false)
                .setLocationForEdit(thingProvider.activeThing!.location);
            final ReminderProvider reminderProvider =
                Provider.of(context, listen: false);
            Provider.of<ThingReminderProvider>(context, listen: false)
                .setThingRemindersForActiveThing(
                    thingProvider.activeThing!, reminderProvider.reminders);

            showModalBottomSheet(
              context: context,
              builder: (ctx) => const AddThing(),
            );
          },
          child: Card(
            color: colorScheme.primaryContainer,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _buildTitleRow(context, textTheme),
                  const SizedBox(height: 10),
                  _buildCategoryIconsRow(),
                  const SizedBox(height: 10),
                  _buildDescriptionRow(textTheme),
                  const Spacer(),
                  _buildActionRow(context, textTheme, colorScheme),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Row _buildTitleRow(BuildContext context, TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            widget.thing.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.displaySmall!
                .copyWith(fontSize: textTheme.displaySmall!.fontSize! - 5.0),
          ),
        ),
        IconButton(
          onPressed: _toggleFavorite,
          icon: Icon(
            _isFavorite ?? false
                ? categoryIcons['favorite']!.iconData
                : Icons.favorite_outline,
            color: _isFavorite ?? false
                ? categoryIcons['favorite']!.iconColor
                : null,
          ),
        ),
      ],
    );
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = _isFavorite != null && !_isFavorite!;
      if (_isFavorite!) {
        widget.thing.categories.add('favorite');
      } else {
        widget.thing.categories.remove('favorite');
      }
      Provider.of<ThingProvider>(context, listen: false)
          .editThing(widget.thing);
    });
  }

  Widget _buildCategoryIconsRow() {
    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.thing.categories
              .where((category) => category != 'favorite')
              .map((category) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      categoryIcons[category]!.iconData,
                      color: categoryIcons[category]!.iconColor,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Row _buildDescriptionRow(TextTheme textTheme) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.thing.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Row _buildActionRow(
      BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Provider.of<ThingProvider>(context, listen: false)
                    .setActiveThing(widget.thing);
                _showNotesDialog(context);
              },
              child: widget.thing.notes == null || widget.thing.notes!.isEmpty
                  ? AppBarIcons().notesIcons.addNoteIcon
                  : AppBarIcons().notesIcons.editNoteIcon,
            ),
            GestureDetector(
              onTap: () {
                Provider.of<ThingProvider>(context, listen: false)
                    .setActiveThing(widget.thing);
                _showLocationDialog(context);
              },
              child: widget.thing.location == null
                  ? AppBarIcons().locationIcons.addLocationIcon
                  : AppBarIcons().locationIcons.containsLocationIcon,
            ),
            GestureDetector(
              onTap: () {
                Provider.of<ThingProvider>(context, listen: false)
                    .setActiveThing(widget.thing);
                final ReminderProvider reminderProvider =
                    Provider.of(context, listen: false);
                Provider.of<ThingReminderProvider>(context, listen: false)
                    .setThingRemindersForActiveThing(widget.thing, reminderProvider.reminders);
                _showThingReminderDialog(context);
              },
              child: widget.thing.remindersExist
                  ? AppBarIcons().thingReminderIcons.containsThingRemindersIcon
                  : AppBarIcons().thingReminderIcons.addThingReminderIcon,
            ),
          ],
        ),
        IconButton(
          icon: Icon(
            Icons.check_box,
            color: _isCompleted ? Colors.green : colorScheme.onPrimary,
          ),
          onPressed: _toggleComplete,
        ),
      ],
    );
  }

  void _toggleComplete() {
    setState(() {
      _isCompleted = !_isCompleted;
      widget.thing.isMarkedComplete = _isCompleted;
      Provider.of<ThingProvider>(context, listen: false)
          .editThing(widget.thing);
    });
  }
}
