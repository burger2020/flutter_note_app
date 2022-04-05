import 'package:flutter_note_app/domain/model/note.dart';
import 'package:flutter_note_app/domain/repository/note_repository.dart';

class DeleteNote {
  DeleteNote(this.repository);

  final NoteRepository repository;

  Future call(Note note) async {
    await repository.deleteNote(note);
  }
}
