import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/models/category.dart';
import 'package:things_app/models/thing.dart';
import 'package:things_app/providers/category_provider.dart';
import 'package:things_app/providers/notes_provider.dart';
import 'package:things_app/providers/reminders_provider.dart';
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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _titleController.text = '';
    _descriptionController.text = '';

    Future.microtask(() {
      final provider = Provider.of<ThingsProvider>(context, listen: false);
      if (provider.isEditMode) {
        _titleController.text = provider.thingInEdit!.title;
        _descriptionController.text = provider.thingInEdit!.description ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Consumer<ThingsProvider>(
      builder: (context, thingProvider, child) {
        void onClose() {
          thingProvider.setThingInEdit(null);
          //Provider.of<ThingReminderProvider>(context, listen: false).reset();
          Navigator.of(context).pop();
        }

        void onAddPressed(
            CategoryProvider categoryProvider, NotesProvider notesProvider) {
          //Create thing with values from the form
          Thing thing = Thing.create(
            title: _titleController.text,
            description: _descriptionController.text,
            categories: categoryProvider.categories,
            isMarkedComplete: false,
            notes: notesProvider.notes,
            reminderIds: thingProvider.remindersForThing.map((r) => r.id).toList(),
          );

          thingProvider.addThing(thing);

          //update reminders
          if(thingProvider.remindersForThing.isNotEmpty){
            Provider.of<RemindersProvider>(context, listen: false).addThingIdToReminders(thingProvider.remindersForThing, thing.id);
          }
        }

        void onEditPressed(
            CategoryProvider categoryProvider, NotesProvider notesProvider) {
          Thing thing = Thing(
            id: thingProvider.thingInEdit!.id,
            title: _titleController.text,
            description: _descriptionController.text,
            categories: categoryProvider.categories,
            isMarkedComplete: false,
            notes: notesProvider.notes,
            reminderIds: thingProvider.remindersForThing.map((r) => r.id).toList(),

          );

          thingProvider.editThing(thing);

          //update reminders
          if(thingProvider.remindersForThing.isNotEmpty){
            Provider.of<RemindersProvider>(context, listen: false).addThingIdToReminders(thingProvider.remindersForThing, thingProvider.thingInEdit!.id);
          }
        }

        void onAddEditPressed() {
          //If input is valid, continue
          if (_formKey.currentState!.validate()) {
            final categoryProvider =
                Provider.of<CategoryProvider>(context, listen: false);
            final notesProvider =
                Provider.of<NotesProvider>(context, listen: false);

            //Validate Categories - return if empty
            if (categoryProvider.categories.isEmpty) {
              return;
            }

            if (thingProvider.isEditMode) {
              onEditPressed(categoryProvider, notesProvider);
            }
            //Add Thing
            else {
              onAddPressed(categoryProvider, notesProvider);
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
                    //Display selected categories
                    const SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SelectedCategories()),
                    const SizedBox(height: 16),

                    //Add Categories
                    DropdownButton<String>(
                      hint: const Text('Select Categories'),
                      value: null,
                      items: categoryIcons.entries
                          .where(
                              (c) => c.key != 'favorite' && c.key != 'complete')
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
                            .addcategory(value);
                      },
                    ),
                    const SizedBox(height: 16),
                    //Add Reminders
                    const AddThingReminderRow(),
                    const SizedBox(height: 16),
                    //Add Notes
                    AddThingNotesRow(
                      thing: thingProvider.thingInEdit,
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.onPrimaryContainer),
                      onPressed: onAddEditPressed,
                      child: Text(
                        'Add',
                        style:
                            textTheme.bodyLarge!.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
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
