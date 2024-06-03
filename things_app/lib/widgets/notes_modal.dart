import 'package:flutter/material.dart';

class NotesModal extends StatefulWidget {
  NotesModal(
      {super.key,
      required this.title,
      required this.notes,
      required this.onEdit,
      required this.onAdd});

  final String title;
  List<String>? notes;
  final void Function(List<String>? note) onEdit;
  final void Function(List<String>? note) onAdd;

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

    void edit(String note, int index) {
      //Switch to display State
      setState(() {
        widget.notes![index] = note.toString();
        //_noteController.text = '';
        _isAdd = false;
        _isEdit = false;
        _isDisplay = true;
      });

      widget.onEdit(widget.notes!);
    }

    void delete(String note) {
      setState(() {
        widget.notes!.remove(note);

        _isAdd = widget.notes?.isEmpty ?? true;
        _isDisplay = widget.notes?.isNotEmpty ?? false;
        _isEdit = false;
        _noteController.text = _isDisplay ? widget.notes![_noteIndex] : '';
      });

      widget.onEdit(widget.notes!);
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

      widget.onAdd(widget.notes!);
    }

    void swipe(String direction) {
      if (direction == 'left') {
        if (_noteIndex == 0) {
          print('already first');
          return;
        }

        setState(() {
          _noteIndex--;
          _noteController.text = widget.notes![_noteIndex];
        });
      }
      if (direction == 'right') {
        if (_noteIndex == widget.notes!.length - 1) {
          print('maxxed');
          return;
        }
        setState(() {
          _noteIndex++;
          _noteController.text = widget.notes![_noteIndex];
        });
      }
    }

    return AlertDialog(
      title: Text(
        '${widget.title} Notes',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: textTheme.displaySmall!.copyWith(
            fontSize: textTheme.displaySmall!.fontSize! - 15.0,
            color: colorScheme.onPrimaryContainer),
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
                              IconButton(
                                onPressed: () {
                                  swipe('left');
                                  print(_noteIndex);
                                },
                                icon: Icon(Icons.arrow_back_ios,
                                    color: colorScheme.primaryContainer),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    _noteController.text,
                                    style: textTheme.displaySmall!.copyWith(
                                      fontSize: textTheme
                                              .displaySmall!.fontSize! -
                                          10,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  swipe('right');
                                  print(_noteIndex);
                                },
                                icon: Icon(Icons.arrow_forward_ios,
                                    color: colorScheme.primaryContainer),
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
  }
}
