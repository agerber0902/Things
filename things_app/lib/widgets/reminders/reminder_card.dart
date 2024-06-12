import 'package:flutter/material.dart';
import 'package:things_app/models/reminder.dart';

class ReminderCard extends StatelessWidget{
  const ReminderCard({super.key, required this.reminder});

  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    return const Card();
  }
}