import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/models/reminder.dart';
import 'package:things_app/models/thing.dart';
import 'package:things_app/providers/reminders_provider.dart';
import 'package:things_app/providers/things_provider.dart';
import 'package:things_app/widgets/reminders/reminder_card.dart';
import 'package:things_app/widgets/shared/animated_opacity_dismissable.dart';
import 'package:things_app/widgets/things/thing_card.dart';

const double cardHeight = 225;

class SharedCardView<T> extends StatelessWidget {
  const SharedCardView({super.key, required this.item});

  final T item;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    Thing thing;
    Reminder reminder;
    String id;
    Widget child;

    if (item.runtimeType == Thing) {
      thing = item as Thing;
      id = thing.id;
      child = ThingCard(
        thing: thing,
      );
    } else {
      reminder = item as Reminder;
      id = reminder.id;
      child = ReminderCard(reminder: reminder);
    }

    void onThingDismissed(Thing thing) {
      ThingsProvider provider =
          Provider.of<ThingsProvider>(context, listen: false);
      provider.deleteThing(thing);

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "${thing.title} was deleted.",
          style: textTheme.bodyLarge!.copyWith(color: colorScheme.onPrimary),
        ),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            provider.addThing(thing);
          },
        ),
      ));
    }

    void onReminderDismissed(Reminder reminder) {
      RemindersProvider provider =
          Provider.of<RemindersProvider>(context, listen: false);
      provider.deleteReminder(reminder);

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "${reminder.title} was deleted.",
          style: textTheme.bodyLarge!.copyWith(color: colorScheme.onPrimary),
        ),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            provider.addReminder(reminder);
          },
        ),
      ));
    }

    return AnimatedOpacityDismissable(
      onDissmissed: (direction) {
        if (item.runtimeType == Thing) {
          onThingDismissed(item as Thing);
        } else {
          onReminderDismissed(item as Reminder);
        }
      },
      childKey: Key(id),
      child: SizedBox(
        height: cardHeight,
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: child,
        ),
      ),
    );
  }
}
