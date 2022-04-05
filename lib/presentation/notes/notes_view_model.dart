import 'package:flutter/material.dart';
import 'package:flutter_note_app/domain/model/note.dart';
import 'package:flutter_note_app/domain/repository/note_repository.dart';
import 'package:flutter_note_app/presentation/notes/notes_event.dart';
import 'package:flutter_note_app/presentation/notes/notes_state.dart';

class NotesViewModel with ChangeNotifier {
  NotesViewModel(this.repository){
    _loadNotes();
  }

  final NoteRepository repository;

  NotesState get state => _state;
  NotesState _state = NotesState();

  Note? _recentlyDeletedNote;

  void onEvent(NotesEvent event) {
    event.when(loadNotes: _loadNotes, deleteNote: _deleteNote, restoreNote: _restoreNote);
  }

  Future<void> _loadNotes() async {
    List<Note> notes = await repository.getNotes();
    _state = state.copyWith(notes: notes);
    notifyListeners();
  }

  Future _deleteNote(Note note) async {
    await repository.deleteNote(note);
    _recentlyDeletedNote = note;
    await _loadNotes();
  }

  Future _restoreNote() async {
    if (_recentlyDeletedNote != null) {
      await repository.insertNote(_recentlyDeletedNote!);
      _recentlyDeletedNote = null;
      _loadNotes();
    }
  }
}
