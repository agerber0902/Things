import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/models/thing.dart';
import 'package:things_app/providers/notes_provider.dart';
import 'package:things_app/utils/icon_data.dart';
import 'package:things_app/widgets/notes/notes_modal.dart';

class AddThingNotesRow extends StatelessWidget {
  const AddThingNotesRow({super.key, this.thing});

  final Thing? thing;

  @override
  Widget build(BuildContext context) {
    //final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Consumer<NotesProvider>(
      builder: (context, notesProvider, child) {
        Future<void> notesDialogBuilder(BuildContext context) {
          return showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return NotesModal(
                    title: thing == null ? '' : thing!.title,
                    notes: thing?.notes,
                    onAdd: (notes) {
                      if (thing != null) {
                        thing!.notes = notes;
                      }
                      //Track notes without a thing
                      else {
                        notesProvider.addNote(notes ?? []);
                      }
                    },
                    onEdit: (notes) {
                      if (thing != null) {
                        thing!.notes = notes;
                      }
                      //Track notes without a thing
                      else {
                        notesProvider.addNote(notes ?? []);
                      }
                    },
                  );
                });
              });
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () {
                notesDialogBuilder(context);
              },
              label: Text(
                notesProvider.notesExist || (thing != null && thing!.notesExist) ? 'Edit Notes' : 'Add Notes',
                style: TextStyle(
                  color: colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
              icon: notesProvider.notesExist || (thing != null && thing!.notesExist)
                  ? containsNoteIcon
                  : addNoteIcon,
            ),
          ],
        );
      },
    );
  }
}
