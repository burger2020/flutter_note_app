import 'package:flutter/material.dart';
import 'package:flutter_note_app/presentation/add_edit_note/add_edit_note_view.dart';
import 'package:flutter_note_app/presentation/notes/component/note_item.dart';
import 'package:flutter_note_app/presentation/notes/notes_event.dart';
import 'package:flutter_note_app/presentation/notes/notes_view_model.dart';
import 'package:provider/provider.dart';

class NotesView extends StatelessWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotesViewModel>();
    final state = vm.state;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Your note", style: TextStyle(fontSize: 30)),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.sort))],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bool? isSaved =
                await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEditNoteView()));

            if (isSaved == true) vm.onEvent(const NotesEvent.loadNotes());
          },
          child: const Icon(Icons.add)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
            children: state.notes
                .map((note) => GestureDetector(
                      onTap: () async {
                        bool? isSaved = await Navigator.push(
                            context, MaterialPageRoute(builder: (context) => AddEditNoteView(note: note)));

                        if (isSaved == true) vm.onEvent(const NotesEvent.loadNotes());
                      },
                      child: NoteItem(
                        note: note,
                        onDeleteClick: () {
                          vm.onEvent(NotesEvent.deleteNote(note));

                          final snackBar = SnackBar(
                              content: const Text("노트가 삭제되었습니다."),
                              action: SnackBarAction(
                                label: '취소',
                                onPressed: () {
                                  vm.onEvent(const NotesEvent.restoreNote());
                                },
                              ));
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                      ),
                    ))
                .toList()),
      ),
    );
  }
}
