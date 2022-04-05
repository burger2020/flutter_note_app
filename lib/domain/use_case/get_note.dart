import 'package:flutter_note_app/domain/model/note.dart';
import 'package:flutter_note_app/domain/repository/note_repository.dart';

class GetNote {
  GetNote(this.repository);

  final NoteRepository repository;

  Future<Note?> call(int id) async {
    return await repository.getNoteById(id);
  }
}
