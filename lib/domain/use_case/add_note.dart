import 'package:flutter_note_app/domain/model/note.dart';
import 'package:flutter_note_app/domain/repository/note_repository.dart';

class AddNote {
  AddNote(this.repository);

  final NoteRepository repository;

  Future call(Note note) async {
    await repository.insertNote(note);
  }
}
