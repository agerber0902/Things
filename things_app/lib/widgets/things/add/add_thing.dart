import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/models/category.dart';
import 'package:things_app/models/thing.dart';
import 'package:things_app/providers/category_provider.dart';
import 'package:things_app/providers/notes_provider.dart';
import 'package:things_app/providers/reminders_provider.dart';
import 'package:things_app/providers/thing_reminder_provider.dart';
import 'package:things_app/providers/things_provider.dart';
import 'package:things_app/utils/value_utils.dart';
import 'package:things_app/widgets/shared/shared_bottom_sheet.dart';
import 'package:things_app/widgets/things/add/add_thing_notes_row.dart';
import 'package:things_app/widgets/things/add/add_thing_reminder_row.dart';
import 'package:things_app/widgets/things/selected_categories.dart';

class AddThing extends StatefulWidget {
  const AddThing({super.key});

  @override
  State<AddThing> createState() => _AddThingState();
}

class _AddThingState extends State<AddThing> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isEdit = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _isEdit = false;

    _titleController.text = '';
    _descriptionController.text = '';

  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final provider = Provider.of<ThingsProvider>(context, listen: false);

    void onClose(){
      Provider.of<CategoryProvider>(context, listen: false).reset();
      Provider.of<NotesProvider>(context, listen: false).reset();
      Provider.of<ThingReminderProvider>(context, listen: false).reset();
      Navigator.of(context).pop();
    }

    void onAddEditPressed() {
      //If input is valid, continue
      if (_formKey.currentState!.validate()) {
        final categoryProvider =
            Provider.of<CategoryProvider>(context, listen: false);
        final notesProvider =
            Provider.of<NotesProvider>(context, listen: false);
        final remindersProvider =
            Provider.of<RemindersProvider>(context, listen: false);
        final thingReminderProvider =
            Provider.of<ThingReminderProvider>(context, listen: false);

        if (_isEdit) {
        }
        //Add Thing
        else {
          //Create thing with values from the form
          Thing thing = Thing.create(
            title: _titleController.text,
            description: _descriptionController.text,
            categories: categoryProvider.categories,
            isMarkedComplete: false,
            notes: notesProvider.notes,
          );

          //Add the thing
          provider.addThing(thing);

          //update the reminders by adding the newly created thing id to the thingids list
          List<String> reminderIds =
              thingReminderProvider.thingRemindersWithReminders.map((r) => r.reminder!.id).toList();
          remindersProvider.addThingIdsToReminders(reminderIds, thing.id);
        }

        //Close the bottom sheet
        onClose();
      }
    }

    return SharedBottomSheet(
      children: [
        Form(
          key: _formKey,
          child: Expanded(
            child: Column(
              children: [
                AddThingTextFormField(
                  controller: _titleController,
                  hintText: ThingsUtils().titleHintText,
                  validationText: ThingsUtils().titleValidationText,
                  maxLength: 50,
                  maxLines: 1,
                ),
                AddThingTextFormField(
                  controller: _descriptionController,
                  hintText: ThingsUtils().descriptionHintText,
                  validationText: ThingsUtils().descriptionValidationText,
                  maxLength: 100,
                  maxLines: 1,
                ),
                const SizedBox(height: 16),
                //Add Reminders
                const AddThingReminderRow(),
                const SizedBox(height: 16),
                //Add Notes
                const AddThingNotesRow(),
                const SizedBox(height: 16),
                //Display selected categories
                !_isEdit
                    ? const SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SelectedCategories(),
                      )
                    : const Placeholder(),

                const SizedBox(height: 16),
                //Add Categories
                DropdownButton<String>(
                  hint: const Text('Select Categories'),
                  value: null,
                  items: categoryIcons.entries
                      .where((c) => c.key != 'favorite' && c.key != 'complete')
                      .map((icon) {
                    return DropdownMenuItem<String>(
                      value: icon.key,
                      child: Row(
                        children: [
                          Icon(
                            icon.value.iconData,
                            color: icon.value.iconColor,
                          ),
                          Text(icon.key),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    Provider.of<CategoryProvider>(context, listen: false)
                        .addcategory(value!);
                  },
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

class AddThingTextFormField extends StatelessWidget {
  const AddThingTextFormField({
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
