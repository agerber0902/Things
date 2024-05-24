import 'package:flutter/material.dart';
import 'package:things_app/models/thing.dart';

const String titleHintText = 'Enter a title';
const String titleValidationText = 'Enter a valid title';

const String descriptionHintText = 'Enter a short description';
const String descriptionValidationText = 'Enter a valid description';

class AddThing extends StatefulWidget {
  const AddThing({
    super.key, required this.addThing,
  });

  final void Function(Thing thingToAdd) addThing;

  @override
  State<AddThing> createState() => _AddThingState();
}

class _AddThingState extends State<AddThing> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _descriptionTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _titleTextController.dispose();
    _descriptionTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
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
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final thingToAdd = Thing.createWithTitleAndDescription(title: _titleTextController.text, description: _descriptionTextController.text);
                                
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

class AddThingTextFormField extends StatelessWidget {
  const AddThingTextFormField(
      {super.key, 
      required this.controller,
      required this.hintText,
      required this.validationText,
      required this.maxLength,
      required this.maxLines,});

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