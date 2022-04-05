import 'package:flutter_note_app/domain/model/note.dart';
import 'package:flutter_note_app/domain/repository/note_repository.dart';

class GetNotes {
  GetNotes(this.repository);

  final NoteRepository repository;

  Future<List<Note>> call() async {
    List<Note> notes = await repository.getNotes();

    return notes;
  }
}
