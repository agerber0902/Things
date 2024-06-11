import 'package:flutter/material.dart';
import 'package:things_app/models/reminder.dart';
import 'package:things_app/models/thing.dart';
import 'package:things_app/screens/things_screen.dart';
import 'package:things_app/widgets/add_reminder.dart';

const double initHeight = 150;

class ReminderView extends StatefulWidget {
  const ReminderView({
    super.key,
    required this.reminder,
    required this.deleteReminder,
    required this.addReminder,
    required this.editReminder,
  });

  final Reminder reminder;
  final void Function(Reminder reminder) deleteReminder;
  final void Function(Reminder reminder) addReminder;
  final void Function(Reminder reminder) editReminder;

  @override
  State<ReminderView> createState() => _ReminderViewState();
}

class _ReminderViewState extends State<ReminderView>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  List<Thing> availableThings = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    getAvailableThings();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    _controller.forward();
  }

  void getAvailableThings() async {
    var things = await fileManager.readThingList();

    setState(() {
      availableThings = things;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Dismissible(
            onDismissed: (direction) {
              Reminder reminder = widget.reminder;
              widget.deleteReminder(widget.reminder);

              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "${reminder.title} was deleted.",
                  style: textTheme.bodyLarge!
                      .copyWith(color: colorScheme.onPrimary),
                ),
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: () {
                    widget.addReminder(reminder);
                  },
                ),
              ));
            },
            key: Key(widget.reminder.id),
            child: SizedBox(
              height: initHeight,
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: ReminderCard(
                  widget: widget,
                  availableThings: availableThings,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ReminderCard extends StatefulWidget {
  const ReminderCard({
    super.key,
    required this.widget,
    required this.availableThings,
  });

  final ReminderView widget;
  final List<Thing> availableThings;

  @override
  State<ReminderCard> createState() => _ReminderCardState();
}

class _ReminderCardState extends State<ReminderCard> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (ctx) {
              return AddReminder(
                addReminder: widget.widget.addReminder,
                editReminder: widget.widget.editReminder,
                reminder: widget.widget.reminder,
                availableThings: widget.availableThings,
              );
            });
      },
      child: Card(
        color: colorScheme.primaryContainer,
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                    widget.widget.reminder.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.displaySmall!.copyWith(
                        fontSize: textTheme.displaySmall!.fontSize! - 5.0),
                  )),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [Text(widget.widget.reminder.reminderDateToDisplay)],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    widget.widget.reminder.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium,
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
