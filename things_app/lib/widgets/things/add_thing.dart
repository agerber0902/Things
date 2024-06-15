import 'package:flutter/material.dart';
import 'package:things_app/models/category.dart';
import 'package:things_app/models/reminder.dart';
import 'package:things_app/models/thing.dart';
import 'package:things_app/screens/things_screen.dart';
import 'package:things_app/widgets/notes_modal.dart';

const String titleHintText = 'Enter a title';
const String titleValidationText = 'Enter a valid title';

const String descriptionHintText = 'Enter a short description';
const String descriptionValidationText = 'Enter a valid description';

const String categoriesValidationText = 'Select at least one category.';

class AddThing extends StatefulWidget {
  const AddThing({
    super.key,
    required this.addThing,
    required this.editThing,
    this.thing,
  });

  final void Function(Thing thingToAdd) addThing;
  final void Function(Thing thingToEdit) editThing;
  final Thing? thing;

  @override
  State<AddThing> createState() => _AddThingState();
}

class _AddThingState extends State<AddThing> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();
  late List<String> _selectedCategories = [];
  String? _selectedDropDownValue;
  late List<String> _notesOnAdd;
  late List<Reminder> _remindersOnAdd;
  late List<Thing> availableThings;

  @override
  void initState() {
    super.initState();

    getAvailableThings();

    _selectedCategories = widget.thing != null ? widget.thing!.categories : [];
    _titleTextController.text = widget.thing != null ? widget.thing!.title : '';
    _descriptionTextController.text =
        widget.thing != null ? widget.thing!.description  : '';
    _notesOnAdd = [];
    _remindersOnAdd = [];
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _descriptionTextController.dispose();
    super.dispose();
  }

  void getAvailableThings() async {
    var things = await fileManager.readThingList();

    setState(() {
      availableThings = things;
    });
    return;
  }

  void removeCategory(String category) {
    setState(() {
      _selectedCategories.remove(category);
    });
  }

  void handleNotes(List<String> notes) {
    setState(() {
      _notesOnAdd = [...notes];
    });
  }

  void handleAddReminder(Reminder reminder) {
    setState(() {
      _remindersOnAdd = [reminder, ..._remindersOnAdd];
    });
  }

  Future<void> _notesDialogBuilder(BuildContext context, Thing? thing) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return NotesModal(
              title: thing != null ? thing.title : '',
              notes: thing != null ? thing.notes : _notesOnAdd,
              onAdd: (notes) {
                handleNotes(notes ?? []);
              },
              onEdit: (notes) {
                handleNotes(notes ?? []);
              },
              onDelete: (notes) {
                handleNotes(notes ?? []);
              },
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

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

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                _notesDialogBuilder(context, widget.thing);
                              },
                              label: Text(
                                _notesOnAdd.isEmpty
                                    ? 'Add Notes'
                                    : 'Edit Notes',
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              icon: _notesOnAdd.isEmpty
                                  ? const Icon(Icons.note_add_outlined)
                                  : const Icon(Icons.sticky_note_2),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        //Display selected categories
                        _selectedCategories.isEmpty
                            ? Text(
                                categoriesValidationText,
                                style: textTheme.bodySmall!
                                    .copyWith(color: colorScheme.error),
                              )
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SelectedCategories(
                                    removeCategory: removeCategory,
                                    selectedCategories: _selectedCategories
                                        .where((c) =>
                                            c != 'favorite' && c != 'complete')
                                        .toList()),
                              ),
                        const SizedBox(height: 16),
                        // DropdownMenu(
                        //   //initialSelection: categoryIcons.entries.first.key,
                        //   initialSelection: _selectedDropDownValue,
                        //   helperText: 'Select Categories',
                        //   hintText: 'Select Categories',
                        //   onSelected: (value) {
                        //     setState(() {
                        //       _selectedCategories.add(value ?? '');
                        //       _selectedDropDownValue = null;
                        //     });
                        //   },
                        //   dropdownMenuEntries:
                        //       categoryIcons.entries.map((icon) {
                        //     return DropdownMenuEntry(
                        //       value: icon.key,
                        //       label: icon.key,
                        //       leadingIcon: Icon(
                        //         icon.value.iconData,
                        //         color: icon.value.iconColor,
                        //       ),
                        //     );
                        //   }).toList(),
                        // ),
                        DropdownButton<String>(
                          hint: const Text('Select Categories'),
                          value: _selectedDropDownValue,
                          items: categoryIcons.entries
                              .where((c) =>
                                  c.key != 'favorite' && c.key != 'complete')
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
                              _selectedCategories.add(value ?? '');
                              _selectedDropDownValue = null;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.onPrimaryContainer),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (_selectedCategories.isEmpty) {
                                return;
                              }

                              //Add
                              if (widget.thing == null) {
                                final thingToAdd =
                                    Thing.createWithTitleAndDescription(
                                        title: _titleTextController.text,
                                        description:
                                            _descriptionTextController.text,
                                        isMarkedComplete: false,
                                        notes: _notesOnAdd,
                                        categories: _selectedCategories
                                            .where((category) => category != '')
                                            .toList());

                                widget.addThing(thingToAdd);

                                Navigator.pop(context);
                              }
                              //edit
                              else {
                                final thingToEdit = Thing(
                                    id: widget.thing!.id,
                                    title: _titleTextController.text,
                                    description:
                                        _descriptionTextController.text,
                                    isMarkedComplete:
                                        widget.thing!.isMarkedComplete,
                                    notes: _notesOnAdd,
                                    categories: _selectedCategories
                                        .where((category) => category != '')
                                        .toList());

                                widget.editThing(thingToEdit);

                                Navigator.pop(context);
                              }
                            }
                          },
                          child: Text(
                            widget.thing == null ? 'Add' : 'Save',
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
