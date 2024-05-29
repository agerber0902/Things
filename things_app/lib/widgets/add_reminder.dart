import 'package:flutter/material.dart';
import 'package:things_app/models/category.dart';
import 'package:things_app/models/reminder.dart';

const String titleHintText = 'Enter a title';
const String titleValidationText = 'Enter a valid title';

const String messageHintText = 'Enter a message';
const String messageValidationText = 'Enter a valid message';

class AddReminder extends StatefulWidget {
  const AddReminder(
      {super.key,
      required this.addReminder,
      required this.editReminder,
      this.reminder});

  final void Function(Reminder reminderToAdd) addReminder;
  final void Function(Reminder reminderToEdit) editReminder;
  final Reminder? reminder;

  @override
  State<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _messageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _messageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

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
                onPressed: () {},
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
                            maxLength: 25,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.onPrimaryContainer,
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                //add
                                if (widget.reminder == null) {
                                  final reminderToAdd = Reminder(
                                    title: _titleTextController.text,
                                    message: _messageTextController.text,
                                  );

                                  widget.addReminder(reminderToAdd);
                                }
                                //edit
                                else{
                                  final reminderToEdit = Reminder.forEdit(
                                    id: widget.reminder!.id,
                                    title: _titleTextController.text,
                                    message: _messageTextController.text,
                                  );

                                  widget.editReminder(reminderToEdit);
                                }

                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              widget.reminder == null ? 'Add' : 'Save',
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
