import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/providers/note_provider.dart';
import 'package:things_app/providers/thing_provider.dart';

// ignore: must_be_immutable
class NotesModal extends StatefulWidget {
  NotesModal({
    super.key,
    required this.title,
    required this.notes,
    required this.isTriggerAdd,
  });

  final String title;
  List<String>? notes;
  bool isTriggerAdd;

  @override
  State<NotesModal> createState() => _NotesModalState();
}

class _NotesModalState extends State<NotesModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _noteController = TextEditingController();

  late bool _isEdit;
  late bool _isAdd;
  late bool _isDisplay;
  late int _noteIndex;

  @override
  void initState() {
    super.initState();

    _noteIndex = 0;
    _isAdd = widget.notes == null ||
        widget.notes!.isEmpty ||
        (widget.notes?.length == 1 && widget.notes![_noteIndex].isEmpty);
    _isDisplay = widget.notes != null && widget.notes!.isNotEmpty;
    _noteController.text = _isDisplay ? widget.notes![_noteIndex] : '';
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    void swipe(String direction) {
      if (direction == 'left') {
        if (_noteIndex == 0) {
          return;
        }

        setState(() {
          _noteIndex--;
          _noteController.text = widget.notes![_noteIndex];
        });
      }
      if (direction == 'right') {
        if (_noteIndex == widget.notes!.length - 1) {
          return;
        }
        setState(() {
          _noteIndex++;
          _noteController.text = widget.notes![_noteIndex];
        });
      }
    }

    return Consumer2<NotesProvider, ThingProvider>(
      builder: (context, noteProvider, thingProvider, child) {
        void edit(String note, int index) {
          //Switch to display State
          setState(() {
            widget.notes![index] = note.toString();
            //_noteController.text = '';
            _isAdd = false;
            _isEdit = false;
            _isDisplay = true;
          });

          noteProvider.editNotes(note, index);

          if(thingProvider.activeThing != null){
            thingProvider.setActiveThingNotes(noteProvider.notes);
          }
        }

        void delete(String note) {
          setState(() {
            widget.notes!.remove(note);

            //need to decrement the note index to avoid out of range exeption
            _noteIndex = 0; //reset to 0 makes it similar to manage

            _isAdd = widget.notes?.isEmpty ?? true;
            _isDisplay = widget.notes?.isNotEmpty ?? false;
            _isEdit = false;
            _noteController.text = _isDisplay ? widget.notes![_noteIndex] : '';
          });

          noteProvider.deleteNote(note);

          if(thingProvider.activeThing != null){
            thingProvider.setActiveThingNotes(noteProvider.notes);
          }
        }

        void add(String note) {
          setState(() {
            widget.notes = [note, ...widget.notes ?? []];
          });

          //Switch to display State
          setState(() {
            _isAdd = false;
            _isEdit = false;
            _isDisplay = true;
          });

          noteProvider.addNote(note);

          if(thingProvider.activeThing != null){
            thingProvider.setActiveThingNotes(noteProvider.notes);
          }
        }

        return AlertDialog(
          title: Text(
            '${widget.title} Notes',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.displaySmall!.copyWith(
                fontSize: textTheme.displaySmall!.fontSize! - 15.0,
                color: colorScheme.primary),
          ),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: double.maxFinite,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _isDisplay
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Opacity(
                                      opacity: _noteIndex == 0 ? 0 : 1,
                                      child: IconButton(
                                        onPressed: () {
                                          swipe('left');
                                        },
                                        icon: Icon(Icons.arrow_back_ios,
                                            color:
                                                colorScheme.primaryContainer),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          _noteController.text,
                                          style:
                                              textTheme.displaySmall!.copyWith(
                                            fontSize: textTheme
                                                    .displaySmall!.fontSize! -
                                                10,
                                            color: colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Opacity(
                                      opacity: widget.notes != null &&
                                              _noteIndex ==
                                                  widget.notes!.length - 1
                                          ? 0
                                          : 1,
                                      child: IconButton(
                                        onPressed: () {
                                          swipe('right');
                                        },
                                        icon: Icon(Icons.arrow_forward_ios,
                                            color:
                                                colorScheme.primaryContainer),
                                      ),
                                    ),
                                  ],
                                )
                              : TextFormField(
                                  controller: _noteController,
                                  enabled: _isAdd || _isEdit,
                                  maxLength: 100,
                                  maxLines: null,
                                  style: textTheme.bodyLarge!
                                      .copyWith(color: colorScheme.primary),
                                  decoration: InputDecoration(
                                    hintText: 'Add a note..',
                                    labelStyle:
                                        TextStyle(color: colorScheme.primary),
                                    hintStyle:
                                        TextStyle(color: colorScheme.primary),
                                  ),
                                  validator: (value) {
                                    if (value == '') {
                                      return 'Please enter a note.';
                                    }
                                    if (value != null && value.contains(';')) {
                                      return 'Please do not use semi colons.';
                                    }
                                    return null;
                                  },
                                ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: _isDisplay,
                                child: TextButton(
                                  onPressed: () {
                                    delete(_noteController.text);
                                    return;
                                  },
                                  child: Text(
                                    'Delete',
                                    style: textTheme.bodySmall!
                                        .copyWith(color: colorScheme.error),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (_isAdd) {
                                    if (_formKey.currentState!.validate()) {
                                      //Add note
                                      add(_noteController.text);
                                      return;
                                    }
                                  }
                                  if (_isDisplay) {
                                    setState(() {
                                      _isEdit = true;
                                      _isAdd = false;
                                      _isDisplay = false;
                                    });
                                    return;
                                  }
                                  if (_isEdit) {
                                    if (_formKey.currentState!.validate()) {
                                      //Add note
                                      edit(_noteController.text, _noteIndex);
                                      return;
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        colorScheme.onPrimaryContainer),
                                child: Text(
                                  _isAdd
                                      ? 'Add'
                                      : _isDisplay
                                          ? 'Edit'
                                          : _isEdit
                                              ? 'Save'
                                              : '',
                                  style: textTheme.bodyLarge!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: _isDisplay,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _isAdd = true;
                                  _isDisplay = false;
                                  _isEdit = false;
                                  _noteController.text = '';
                                });
                                return;
                              },
                              child: Text(
                                'Add new note',
                                style: textTheme.bodySmall!.copyWith(
                                  color: colorScheme.primary,
                                  decorationColor: colorScheme.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
