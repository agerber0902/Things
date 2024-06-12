import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:things_app/models/reminder.dart';
import 'package:things_app/providers/reminders_provider.dart';
import 'package:things_app/providers/thing_reminder_provider.dart';
import 'package:things_app/utils/value_utils.dart';
import 'package:things_app/widgets/reminders/add/add_reminder_thing_row.dart';
import 'package:things_app/widgets/shared/selected_thing_view.dart';
import 'package:things_app/widgets/shared/shared_bottom_sheet.dart';

class AddReminder extends StatefulWidget {
  const AddReminder({super.key, required this.isFromModal});

  final bool isFromModal;

  @override
  State<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  DateTime? _selectedDateTime;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isEdit = false;

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _isEdit = false;

    _titleController.text = '';
    _messageController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final provider = Provider.of<RemindersProvider>(context, listen: false);
    final thingReminderProvider =
        Provider.of<ThingReminderProvider>(context, listen: false);

    void onAddEditPressed() {
      //If input is valid, continue
      if (_formKey.currentState!.validate() && _selectedDateTime != null) {
        if (_isEdit) {
        }
        //Add Reminder
        else {
          //Create reminder with values from the form
          Reminder reminder = Reminder.create(
            title: _titleController.text,
            message: _messageController.text,
            date: _selectedDateTime!,
            thingIds: null,
          );
          thingReminderProvider.createReminder(reminder);

          //Add the reminder
          provider.addReminder(reminder);
        }

        //Close the bottom sheet
        Navigator.of(context).pop();
      }
    }

    Future<void> selectDate(BuildContext context) async {
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

    return SharedBottomSheet(
      children: [
        Form(
          key: _formKey,
          child: Expanded(
            child: Column(
              children: [
                AddReminderTextFormField(
                  controller: _titleController,
                  hintText: RemindersUtils().titleHintText,
                  validationText: RemindersUtils().titleValidationText,
                  maxLength: 25,
                  maxLines: 1,
                ),
                AddReminderTextFormField(
                  controller: _messageController,
                  hintText: RemindersUtils().messageHintText,
                  validationText: RemindersUtils().messageValidationText,
                  maxLength: 35,
                  maxLines: 1,
                ),
                const SizedBox(height: 16),
                //Link Things
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      //padding: const EdgeInsets.all(10),
                      //margin: const EdgeInsets.only(left: 10, right: 10),
                      child: Visibility(
                        visible: !widget
                            .isFromModal, //We dont want to show this if it is add thing, only edit thing + reminders
                        child: const AddReminderThingRow(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                //Display selected things
                Visibility(
                  visible: thingReminderProvider.thingRemindersExist,
                  child: const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SelectedThingView(),
                  ),
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () => selectDate(context),
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
                          : textTheme.bodyMedium!
                              .copyWith(color: colorScheme.primary),
                      _selectedDateTime == null
                          ? 'Select date and time'
                          : DateFormat.yMEd()
                              .add_jms()
                              .format(_selectedDateTime!.toLocal())
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
                      backgroundColor: colorScheme.onPrimaryContainer),
                  onPressed: onAddEditPressed,
                  child: Text(
                    'Add',
                    style: textTheme.bodyLarge!.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
        textInputAction: TextInputAction.done,
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
