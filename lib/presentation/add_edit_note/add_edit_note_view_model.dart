import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_note_app/domain/model/note.dart';
import 'package:flutter_note_app/domain/repository/note_repository.dart';
import 'package:flutter_note_app/presentation/add_edit_note/add_edit_note_event.dart';
import 'package:flutter_note_app/presentation/add_edit_note/add_edit_note_ui_event.dart';

import '../../ui/colors.dart';

class AddEditNoteViewModel with ChangeNotifier {
  AddEditNoteViewModel(this.repository);

  final NoteRepository repository;

  int get color => _color;
  int _color = roseBud.value;

  Stream<AddEditNoteUiEvent> get eventStream => _eventController.stream;
  final _eventController = StreamController<AddEditNoteUiEvent>.broadcast();

  void onEvent(AddEditNoteEvent event) {
    event.when(changeColor: _changeColor, saveNote: _saveNote);
  }

  Future _changeColor(int color) async {
    _color = color;
    notifyListeners();
  }

  Future _saveNote(int? id, String title, String content) async {
    if (title.isEmpty || content.isEmpty) {
      _eventController.add(const AddEditNoteUiEvent.showSnackBar("제목이나 내용 입력"));
    } else {
      final note =
          Note(id: id, title: title, content: content, color: _color, timestamp: DateTime.now().millisecondsSinceEpoch);
      if (id == null) {
        repository.insertNote(note);
      } else {
        repository.updateNote(note);
      }
      _eventController.add(const AddEditNoteUiEvent.saveNote());
    }
  }
}
