import 'package:flutter_note_app/domain/model/note.dart';
import 'package:sqflite/sqlite_api.dart';

class NoteDBHelper {
  Database db;

  NoteDBHelper(this.db);

  Future<Note?> getNoteById(int id) async {
    // select * from note where id = {id}
    final List<Map<String, dynamic>> maps = await db.query(
      'note',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Note>> getNotes() async {
    final List<Map<String, dynamic>> maps = await db.query('note');

    return maps.map((e) => Note.fromJson(e)).toList();
  }

  Future insertNote(Note note) async {
    await db.insert('note', note.toJson());
  }

  Future updateNote(Note note) async {
    await db.update('note', note.toJson(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future deleteNote(Note note) async {
    await db.delete('note', where: 'id = ?', whereArgs: [note.id]);
  }
}
