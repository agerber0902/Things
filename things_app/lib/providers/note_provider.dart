import 'package:flutter/material.dart';

class NotesProvider extends ChangeNotifier {
  List<String>? _notes;
  List<String>? get notes => _notes;
  bool get notesExist => _notes != null && _notes!.isNotEmpty;
  
  void addNotesForEdit(List<String>? notesToAdd){
    _notes = notesToAdd;
    notifyListeners();
  }
  void addNote(String note) {
    _notes = [note, ...?_notes];
    notifyListeners();
  }
  void deleteNote(String note) {
    _notes?.remove(note);
    notifyListeners();
  }
  void editNotes(String note, int index) {
    _notes?[index] = note;
    notifyListeners();
  }
  void reset(){
    _notes = null;
    notifyListeners();
  }
}