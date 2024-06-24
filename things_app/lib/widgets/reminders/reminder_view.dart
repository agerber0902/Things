import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/models/reminder.dart';
import 'package:things_app/providers/reminder_provider.dart';
import 'package:things_app/widgets/reminders/add_reminder.dart';

const double initHeight = 150;

class ReminderView extends StatefulWidget {
  const ReminderView({super.key, required this.reminder});

  final Reminder reminder;

  @override
  State<ReminderView> createState() => _ReminderViewState();
}

class _ReminderViewState extends State<ReminderView> with TickerProviderStateMixin {
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

    return Consumer<ReminderProvider>(
      builder: (context, reminderProvider, child) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Opacity(
              opacity: _animation.value,
              child: Dismissible(
                key: Key(widget.reminder.id),
                onDismissed: (direction) {
                  Reminder reminder = widget.reminder;
                  reminderProvider.deleteReminder(reminder);

                  ScaffoldMessenger.of(context)
                    ..clearSnackBars()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          "${reminder.title} was deleted.",
                          style: textTheme.bodyLarge!.copyWith(color: colorScheme.onPrimary),
                        ),
                        action: SnackBarAction(
                          label: "Undo",
                          onPressed: () {
                            reminderProvider.addReminder(reminder);
                          },
                        ),
                      ),
                    );
                },
                child: SizedBox(
                  height: initHeight,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ReminderCard(reminder: widget.reminder),
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

class ReminderCard extends StatelessWidget {
  const ReminderCard({super.key, required this.reminder});

  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        Provider.of<ReminderProvider>(context, listen: false).setActiveReminder(reminder);

        showModalBottomSheet(
          context: context,
          builder: (ctx) => const AddReminder(),
        );
      },
      child: Card(
        color: colorScheme.primaryContainer,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reminder.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.displaySmall!.copyWith(fontSize: textTheme.displaySmall!.fontSize! - 5.0),
              ),
              const SizedBox(height: 10),
              Text(reminder.reminderDateToDisplay),
              const SizedBox(height: 10),
              Text(
                reminder.message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
