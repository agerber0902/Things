import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/models/reminder.dart';
import 'package:intl/intl.dart';
import 'package:things_app/providers/reminder_provider.dart';

const String titleHintText = 'Enter a title';
const String titleValidationText = 'Enter a valid title';

const String messageHintText = 'Enter a message';
const String messageValidationText = 'Enter a valid message';

class AddReminder extends StatefulWidget {
  const AddReminder({
    super.key,
  });

  @override
  State<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _messageTextController = TextEditingController();
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Reminder? activeReminder =
          Provider.of<ReminderProvider>(context, listen: false).activeReminder;

      if (activeReminder != null) {
        setState(() {
          _titleTextController.text =
              activeReminder.title;
          _messageTextController.text =
              activeReminder.message;
          _selectedDateTime = activeReminder.date;
        });
      }
    });
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _messageTextController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime:
            TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Consumer<ReminderProvider>(
      builder: (context, reminderProvider, child) {
        return SizedBox(
          height: 600,
          width: double.infinity,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    padding: const EdgeInsets.all(8),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Row(
                    children: [
                      Form(
                        key: _formKey,
                        child: Expanded(
                          child: Column(
                            children: [
                              AddReminderTextFormField(
                                controller: _titleTextController,
                                hintText: titleHintText,
                                validationText: titleValidationText,
                                maxLength: 25,
                                maxLines: 1,
                              ),
                              AddReminderTextFormField(
                                controller: _messageTextController,
                                hintText: messageHintText,
                                validationText: messageValidationText,
                                maxLength: 35,
                                maxLines: 1,
                              ),
                              ElevatedButton(
                                onPressed: () => _selectDate(context),
                                child: const Text(
                                  'Select date',
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 10),
                                  Text(
                                    style: _selectedDateTime == null
                                        ? textTheme.bodySmall!
                                            .copyWith(color: colorScheme.error)
                                        : textTheme.bodyMedium!.copyWith(
                                            color: colorScheme.primary),
                                    _selectedDateTime == null
                                        ? 'Select date and time'
                                        : DateFormat.yMEd()
                                            .add_jms()
                                            .format(
                                                _selectedDateTime!.toLocal())
                                            .split('.')[0],
                                  ),
                                  Visibility(
                                    visible: _selectedDateTime != null,
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _selectedDateTime = null;
                                        });
                                      },
                                      icon: const Icon(Icons.close),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      colorScheme.onPrimaryContainer,
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    //validate date
                                    if (_selectedDateTime == null) {
                                      return;
                                    }

                                    //add
                                    if (reminderProvider.activeReminder ==
                                        null) {
                                      final reminderToAdd = Reminder(
                                        title: _titleTextController.text,
                                        message: _messageTextController.text,
                                        date:
                                            _selectedDateTime ?? DateTime.now(),
                                      );

                                      reminderProvider
                                          .addReminder(reminderToAdd);
                                    }
                                    //edit
                                    else {
                                      final reminderToEdit = Reminder.forEdit(
                                        id: reminderProvider.activeReminder!.id,
                                        title: _titleTextController.text,
                                        message: _messageTextController.text,
                                        date:
                                            _selectedDateTime ?? DateTime.now(),
                                      );

                                      reminderProvider
                                          .editReminder(reminderToEdit);
                                    }

                                    Navigator.pop(context);
                                  }
                                },
                                child: Text(
                                  reminderProvider.activeReminder == null
                                      ? 'Add'
                                      : 'Save',
                                  style: textTheme.bodyLarge!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AddReminderTextFormField extends StatelessWidget {
  const AddReminderTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validationText,
    required this.maxLength,
    required this.maxLines,
  });

  final TextEditingController controller;
  final String hintText;
  final String validationText;
  final int maxLength;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: TextFormField(
        maxLength: maxLength,
        maxLines: maxLines,
        controller: controller,
        style: textTheme.bodyLarge!.copyWith(color: colorScheme.primary),
        decoration: InputDecoration(
          hintText: hintText,
          labelStyle: TextStyle(color: colorScheme.primary),
          hintStyle: TextStyle(color: colorScheme.primary),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validationText;
          }
          return null;
        },
      ),
    );
  }
}
