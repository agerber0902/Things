import 'package:flutter/material.dart';

class NotesProvider extends ChangeNotifier {
  List<String>? _notes;
  List<String>? get notes => _notes;
  bool get notesExist => _notes != null && _notes!.isNotEmpty;
  
  void addNote(List<String> note) {
    _notes = [...note];
    print(_notes);
    notifyListeners();
  }
  void deleteNote(String note) {
    _notes?.remove(note);
    print(_notes);
    notifyListeners();
  }
  void editNote(String note, int index) {
    _notes?[index] = note;
    print(_notes);
    notifyListeners();
  }
  void reset(){
    _notes = null;
    notifyListeners();
  }
}
