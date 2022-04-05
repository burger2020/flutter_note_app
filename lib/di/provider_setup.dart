import 'package:flutter_note_app/data/data_source/note_db_helper.dart';
import 'package:flutter_note_app/data/repository/note_repository_impl.dart';
import 'package:flutter_note_app/presentation/add_edit_note/add_edit_note_view_model.dart';
import 'package:flutter_note_app/presentation/notes/notes_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sqflite/sqflite.dart';

Future<List<SingleChildWidget>> getProviders() async {
  Database database = await openDatabase('note_db', version: 1, onCreate: (db, version) async {
    await db.execute(
        'CREATE TABLE note (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT, color INTEGER, timestamp INTEGER)');
  });

  var noteDbHelper = NoteDBHelper(database);
  var noteRepository = NoteRepositoryImpl(noteDbHelper);
  var notesViewModel = NotesViewModel(noteRepository);
  var addEditNoteViewModel = AddEditNoteViewModel(noteRepository);

  return [
    ChangeNotifierProvider(create: (_) => notesViewModel),
    ChangeNotifierProvider(create: (_) => addEditNoteViewModel),
  ];
}
