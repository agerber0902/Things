import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/models/category.dart';
import 'package:things_app/models/thing.dart';
import 'package:things_app/providers/category_provider.dart';
import 'package:things_app/providers/location_provider.dart';
import 'package:things_app/providers/note_provider.dart';
import 'package:things_app/providers/thing_provider.dart';
import 'package:things_app/providers/thing_reminder_provider.dart';
import 'package:things_app/utils/icon_data.dart';
import 'package:things_app/widgets/location/location_modal.dart';
import 'package:things_app/widgets/notes_modal.dart';

const String titleHintText = 'Enter a title';
const String titleValidationText = 'Enter a valid title';

const String descriptionHintText = 'Enter a short description';
const String descriptionValidationText = 'Enter a valid description';

const String categoriesValidationText = 'Select at least one category.';

class AddThing extends StatefulWidget {
  const AddThing({
    super.key,
  });

  @override
  State<AddThing> createState() => _AddThingState();
}

class _AddThingState extends State<AddThing> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Thing? activeThing =
          Provider.of<ThingProvider>(context, listen: false).activeThing;

      if (activeThing != null) {
        setState(() {
          _titleTextController.text = activeThing.title;
          _descriptionTextController.text = activeThing.description;
        });
      }
    });
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _descriptionTextController.dispose();
    super.dispose();
  }

  Future<void> _notesDialogBuilder(BuildContext context, Thing? thing) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return NotesModal(
              title: thing != null ? thing.title : '',
              notes: thing != null ? thing.notes : [],
              isTriggerAdd: false,
            );
          });
        });
  }

  Future<void> _locationDialogBuilder(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return const LocationModal();
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Consumer<ThingProvider>(
      builder: (context, thingProvider, child) {
        return SizedBox(
          height: MediaQuery.of(context).size.height - kToolbarHeight,
          child: SingleChildScrollView(
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
                Row(
                  children: [
                    Form(
                      key: _formKey,
                      child: Expanded(
                        child: Column(
                          children: [
                            AddThingTextFormField(
                              controller: _titleTextController,
                              hintText: titleHintText,
                              validationText: titleValidationText,
                              maxLength: 50,
                              maxLines: 1,
                            ),
                            AddThingTextFormField(
                              controller: _descriptionTextController,
                              hintText: descriptionHintText,
                              validationText: descriptionValidationText,
                              maxLength: 100,
                              maxLines: 1,
                            ),

                            const SizedBox(height: 16),

                            //Reminders
                            Consumer2<ThingReminderProvider, ThingProvider>(builder:(context, value, value2, child) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //TextButton.icon(onPressed: (){}, label: Text(thingProvider.activeThing != null && thingProvider.activeThing!.reminder))
                                ],
                              )
                            },),
                            const SizedBox(height: 16),

                            //Notes
                            Consumer2<NotesProvider, ThingProvider>(
                              builder: (context, noteProvider, thingProvider,
                                  child) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        _notesDialogBuilder(
                                            context, thingProvider.activeThing);
                                      },
                                      label: Text(
                                        thingProvider.activeThing != null &&
                                                thingProvider.activeThing!.notesExist || (noteProvider.notesExist)
                                            ? 'Edit Notes'
                                            : 'Add Notes',
                                        style: TextStyle(
                                          color: colorScheme.primary,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      icon: thingProvider.activeThing != null &&
                                              thingProvider.activeThing!.notesExist || (noteProvider.notesExist)
                                          ? AppBarIcons()
                                              .notesIcons
                                              .editNoteIcon
                                          : AppBarIcons()
                                              .notesIcons
                                              .addNoteIcon,
                                    ),
                                  ],
                                );
                              },
                            ),

                            const SizedBox(height: 16),

                            //Location
                            Consumer2<LocationProvider, ThingProvider>(builder:(context, locationProvider, thingProvider, child) {
                              return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton.icon(
                                      onPressed: () {
                                        _locationDialogBuilder(context);
                                      },
                                      label: Text(
                                        thingProvider.activeThing != null &&
                                                thingProvider.activeThing!.location != null || (locationProvider.location != null)
                                            ? 'Edit Location'
                                            : 'Add Location',
                                        style: TextStyle(
                                          color: colorScheme.primary,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      icon:
                                      thingProvider.activeThing != null &&
                                              thingProvider.activeThing!.location != null || (locationProvider.location != null)
                                          ? AppBarIcons()
                                              .locationIcons.containsLocationIcon
                                           : AppBarIcons().locationIcons.addLocationIcon,
                                    ),
                              ],
                            );

                            },), 
                            const SizedBox(height: 16),

                            //Display selected categories
                            Consumer<CategoryProvider>(
                              builder: (context, categoryProvider, child) {
                                return categoryProvider.categories.isEmpty
                                    ? Text(
                                        categoriesValidationText,
                                        style: textTheme.bodySmall!
                                            .copyWith(color: colorScheme.error),
                                      )
                                    : SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: SelectedCategories(
                                            removeCategory:
                                                categoryProvider.deletecategory,
                                            selectedCategories: categoryProvider
                                                .categories
                                                .where((c) =>
                                                    c != 'favorite' &&
                                                    c != 'complete')
                                                .toList()),
                                      );
                              },
                            ),
                            const SizedBox(height: 16),

                            DropdownButton<String>(
                              hint: const Text('Select Categories'),
                              value: null,
                              items: categoryIcons.entries
                                  .where((c) =>
                                      c.key != 'favorite' &&
                                      c.key != 'complete')
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
                                setState(() {
                                  Provider.of<CategoryProvider>(context,
                                          listen: false)
                                      .addcategory(value ?? '');
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      colorScheme.onPrimaryContainer),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (Provider.of<CategoryProvider>(context,
                                          listen: false)
                                      .categories
                                      .isEmpty) {
                                    return;
                                  }

                                  //Add
                                  if (thingProvider.activeThing == null) {
                                    final thingToAdd =
                                        Thing.createWithTitleAndDescription(
                                            title: _titleTextController.text,
                                            description:
                                                _descriptionTextController.text,
                                            isMarkedComplete: false,
                                            notes: Provider.of<NotesProvider>(
                                                    context,
                                                    listen: false)
                                                .notes,
                                            location: Provider.of<LocationProvider>(context, listen: false).location,
                                            categories:
                                                Provider.of<CategoryProvider>(
                                                        context,
                                                        listen: false)
                                                    .categories
                                                    .where((category) =>
                                                        category != '')
                                                    .toList());

                                    thingProvider.addThing(thingToAdd);
                                    //Reset Notes
                                    //Provider.of<NotesProvider>(context, listen: false).reset();

                                    Navigator.pop(context);
                                  }
                                  //edit
                                  else {
                                    final thingToEdit = Thing(
                                        id: thingProvider.activeThing!.id,
                                        title: _titleTextController.text,
                                        description:
                                            _descriptionTextController.text,
                                        isMarkedComplete:
                                            thingProvider.activeThing!.isMarkedComplete,
                                        notes: Provider.of<NotesProvider>(
                                                context,
                                                listen: false)
                                            .notes,
                                        location: Provider.of<LocationProvider>(context, listen: false).location,
                                        categories: Provider.of<
                                                    CategoryProvider>(context,
                                                listen: false)
                                            .categories
                                            .where((category) => category != '')
                                            .toList());

                                    thingProvider.editThing(thingToEdit);

                                    //Reset Notes
                                    //Provider.of<NotesProvider>(context, listen: false).reset();

                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child: Text(
                                thingProvider.activeThing == null ? 'Add' : 'Save',
                                style: textTheme.bodyLarge!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SelectedCategories extends StatefulWidget {
  const SelectedCategories({
    super.key,
    required List<String> selectedCategories,
    required this.removeCategory,
  }) : _selectedCategories = selectedCategories;

  final List<String> _selectedCategories;
  final void Function(String category) removeCategory;

  @override
  State<SelectedCategories> createState() => _SelectedCategoriesState();
}

class _SelectedCategoriesState extends State<SelectedCategories> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget._selectedCategories.where((sc) => sc != '').map((c) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            color: colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    c,
                    style: textTheme.displaySmall!.copyWith(fontSize: 18),
                  ),
                  const SizedBox(width: 10),
                  Icon(categoryIcons[c]!.iconData,
                      color: categoryIcons[c]!.iconColor),
                  const SizedBox(width: 5),
                  Opacity(
                    opacity: 0.4,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        widget.removeCategory(c);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
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
