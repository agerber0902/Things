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
  const AddThing({super.key});

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
      final activeThing =
          Provider.of<ThingProvider>(context, listen: false).activeThing;
      if (activeThing != null) {
        _titleTextController.text = activeThing.title;
        _descriptionTextController.text = activeThing.description;
      }
    });
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _descriptionTextController.dispose();
    super.dispose();
  }

  Future<void> _showNotesDialog(BuildContext context, Thing? thing) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return NotesModal(
          title: thing?.title ?? '',
          notes: thing?.notes ?? [],
          isTriggerAdd: false,
        );
      },
    );
  }

  Future<void> _showLocationDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return const LocationModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<ThingProvider>(
      builder: (context, thingProvider, child) {
        return SizedBox(
          height: MediaQuery.of(context).size.height - kToolbarHeight,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ),
                  Form(
                    key: _formKey,
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
                        Consumer2<NotesProvider, ThingProvider>(
                          builder:
                              (context, notesProvider, thingProvider, child) {
                            return _buildNotesButton(context, colorScheme,
                                textTheme, notesProvider, thingProvider);
                          },
                        ),
                        const SizedBox(height: 16),
                        Consumer2<LocationProvider, ThingProvider>(
                          builder: (context, locationProvider, thingProvider,
                              child) {
                            return _buildLocationButton(context, colorScheme,
                                textTheme, locationProvider, thingProvider);
                          },
                        ),
                        const SizedBox(height: 16),
                        Consumer2<ThingReminderProvider, ThingProvider>(
                          builder: (context, thingReminderProvider,
                              thingProvider, child) {
                            return _buildThingReminderSection(
                                context,
                                textTheme,
                                colorScheme,
                                thingReminderProvider,
                                thingProvider);
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildCategoriesSection(
                            context, textTheme, colorScheme),
                        const SizedBox(height: 16),
                        _buildCategoryDropdown(context),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.onPrimaryContainer),
                          onPressed: () => _onSubmit(context, thingProvider),
                          child: Text(
                            thingProvider.activeThing == null ? 'Add' : 'Save',
                            style: textTheme.bodyLarge!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildThingReminderSection(
      BuildContext context,
      TextTheme textTheme,
      ColorScheme colorScheme,
      ThingReminderProvider thingReminderProvider,
      ThingProvider thingProvider) {
    return Row(
      children: [
        TextButton.icon(
          onPressed: () {
            //TODO
          },
          //TODO: add thingProvider.activeThing?.reminders != null) to check
          label: Text(
            'Add Reminders',
            style: TextStyle(
                color: colorScheme.primary,
                decoration: TextDecoration.underline),
          ),
          icon: AppBarIcons().thingReminderIcons.addThingReminderIcon,
        ),
      ],
    );
  }

  Widget _buildNotesButton(
      BuildContext context,
      ColorScheme colorScheme,
      TextTheme textTheme,
      NotesProvider notesProvider,
      ThingProvider thingProvider) {
    return Row(
      children: [
        TextButton.icon(
          onPressed: () => _showNotesDialog(context, thingProvider.activeThing),
          label: Text(
            thingProvider.activeThing?.notesExist ?? notesProvider.notesExist
                ? 'Edit Notes'
                : 'Add Notes',
            style: TextStyle(
                color: colorScheme.primary,
                decoration: TextDecoration.underline),
          ),
          icon:
              thingProvider.activeThing?.notesExist ?? notesProvider.notesExist
                  ? AppBarIcons().notesIcons.editNoteIcon
                  : AppBarIcons().notesIcons.addNoteIcon,
        ),
      ],
    );
  }

  Widget _buildLocationButton(
      BuildContext context,
      ColorScheme colorScheme,
      TextTheme textTheme,
      LocationProvider locationProvider,
      ThingProvider thingProvider) {
    return Row(
      children: [
        TextButton.icon(
          onPressed: () => _showLocationDialog(context),
          label: Text(
            thingProvider.activeThing?.location != null ||
                    locationProvider.location != null
                ? 'Edit Location'
                : 'Add Location',
            style: TextStyle(
                color: colorScheme.primary,
                decoration: TextDecoration.underline),
          ),
          icon: thingProvider.activeThing?.location != null ||
                  locationProvider.location != null
              ? AppBarIcons().locationIcons.containsLocationIcon
              : AppBarIcons().locationIcons.addLocationIcon,
        ),
      ],
    );
  }

  Widget _buildCategoriesSection(
      BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        if (categoryProvider.categories.isEmpty) {
          return Text(categoriesValidationText,
              style: textTheme.bodySmall!.copyWith(color: colorScheme.error));
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SelectedCategories(
            removeCategory: categoryProvider.deletecategory,
            selectedCategories: categoryProvider.categories
                .where((c) => c != 'favorite' && c != 'complete')
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildCategoryDropdown(BuildContext context) {
    return DropdownButton<String>(
      hint: const Text('Select Categories'),
      value: null,
      items: categoryIcons.entries
          .where((c) => c.key != 'favorite' && c.key != 'complete')
          .map((icon) {
        return DropdownMenuItem<String>(
          value: icon.key,
          child: Row(
            children: [
              Icon(icon.value.iconData, color: icon.value.iconColor),
              Text(icon.key),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          Provider.of<CategoryProvider>(context, listen: false)
              .addcategory(value);
        }
      },
    );
  }

  void _onSubmit(BuildContext context, ThingProvider thingProvider) {
    if (_formKey.currentState?.validate() ?? false) {
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);
      final locationProvider =
          Provider.of<LocationProvider>(context, listen: false);

      if (categoryProvider.categories.isEmpty) {
        return;
      }

      if (thingProvider.activeThing == null) {
        final newThing = Thing.createWithTitleAndDescription(
          title: _titleTextController.text,
          description: _descriptionTextController.text,
          isMarkedComplete: false,
          notes: notesProvider.notes,
          location: locationProvider.location,
          categories: categoryProvider.categories
              .where((category) => category.isNotEmpty)
              .toList(),
        );
        thingProvider.addThing(newThing);
      } else {
        final editedThing = Thing(
          id: thingProvider.activeThing!.id,
          title: _titleTextController.text,
          description: _descriptionTextController.text,
          isMarkedComplete: thingProvider.activeThing!.isMarkedComplete,
          notes: notesProvider.notes,
          location: locationProvider.location,
          categories: categoryProvider.categories
              .where((category) => category.isNotEmpty)
              .toList(),
        );
        thingProvider.editThing(editedThing);
      }

      Navigator.pop(context);
    }
  }
}

class SelectedCategories extends StatelessWidget {
  const SelectedCategories({
    super.key,
    required this.selectedCategories,
    required this.removeCategory,
  });

  final List<String> selectedCategories;
  final void Function(String category) removeCategory;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: selectedCategories.map((category) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            color: colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(category,
                      style: textTheme.displaySmall!.copyWith(fontSize: 18)),
                  const SizedBox(width: 10),
                  Icon(categoryIcons[category]!.iconData,
                      color: categoryIcons[category]!.iconColor),
                  const SizedBox(width: 5),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => removeCategory(category),
                    color: colorScheme.onPrimaryContainer.withOpacity(0.4),
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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        maxLength: maxLength,
        maxLines: maxLines,
        textInputAction: TextInputAction.done,
        style: textTheme.bodyLarge!.copyWith(color: colorScheme.primary),
        decoration: InputDecoration(
          hintText: hintText,
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

//TODO: make the bottom sheet bigger
