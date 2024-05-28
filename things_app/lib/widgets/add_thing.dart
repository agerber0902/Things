import 'package:flutter/material.dart';
import 'package:things_app/models/category.dart';
import 'package:things_app/models/thing.dart';

const String titleHintText = 'Enter a title';
const String titleValidationText = 'Enter a valid title';

const String descriptionHintText = 'Enter a short description';
const String descriptionValidationText = 'Enter a valid description';

class AddThing extends StatefulWidget {
  const AddThing({
    super.key,
    required this.addThing,
  });

  final void Function(Thing thingToAdd) addThing;

  @override
  State<AddThing> createState() => _AddThingState();
}

class _AddThingState extends State<AddThing> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();
  late List<String> _selectedCategories = [];

  @override
  void initState() {
    super.initState();

    _selectedCategories = [];
  }

  @override
  void dispose() {
    super.dispose();
    _titleTextController.dispose();
    _descriptionTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 550,
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
                mainAxisSize: MainAxisSize.min,
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
                            maxLines: 2,
                          ),
                          const SizedBox(height: 16),
                          //Display selected categories
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SelectedCategories(
                                selectedCategories: _selectedCategories),
                          ),
                          const SizedBox(height: 16),
                          DropdownMenu(
                            onSelected: (value) {
                              setState(() {
                                _selectedCategories.add(value ?? '');
                              });
                            },
                            dropdownMenuEntries:
                                categoryIcons.entries.map((icon) {
                              return DropdownMenuEntry(
                                value: icon.key,
                                label: icon.key,
                                leadingIcon: Icon(icon.value),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final thingToAdd =
                                    Thing.createWithTitleAndDescription(
                                        title: _titleTextController.text,
                                        description:
                                            _descriptionTextController.text,
                                        categories: _selectedCategories);

                                widget.addThing(thingToAdd);

                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectedCategories extends StatefulWidget {
  const SelectedCategories({
    super.key,
    required List<String> selectedCategories,
  }) : _selectedCategories = selectedCategories;

  final List<String> _selectedCategories;

  @override
  State<SelectedCategories> createState() => _SelectedCategoriesState();
}

class _SelectedCategoriesState extends State<SelectedCategories> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget._selectedCategories.map((c) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(c),
                  const SizedBox(width: 10),
                  Icon(categoryIcons[c]),
                  const SizedBox(width: 5),
                  Opacity(
                    opacity: 0.4,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          widget._selectedCategories.remove(c);
                        });
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: TextFormField(
        maxLength: maxLength,
        maxLines: maxLines,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
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
