import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_note_app/domain/model/note.dart';
import 'package:flutter_note_app/presentation/add_edit_note/add_edit_note_event.dart';
import 'package:flutter_note_app/presentation/add_edit_note/add_edit_note_view_model.dart';
import 'package:flutter_note_app/ui/colors.dart';
import 'package:provider/provider.dart';

class AddEditNoteView extends StatefulWidget {
  const AddEditNoteView({Key? key, this.note}) : super(key: key);

  final Note? note;

  @override
  State<AddEditNoteView> createState() => _AddEditNoteViewState();
}

class _AddEditNoteViewState extends State<AddEditNoteView> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  StreamSubscription? _streamSubscription;

  final List<Color> noteColors = [roseBud, primrose, wisteria, skyBlue, illusion];

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }

    Future.microtask(() {
      final vm = context.read<AddEditNoteViewModel>();
      _streamSubscription = vm.eventStream.listen((event) {
        event.when(saveNote: () {
          Navigator.pop(context, true);
        }, showSnackBar: (String message) {
          var snackBar = const SnackBar(content: Text("제목이나 내용 입력"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      });
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AddEditNoteViewModel>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var event = AddEditNoteEvent.saveNote(
            widget.note == null ? null : widget.note!.id,
            _titleController.text,
            _contentController.text,
          );
          vm.onEvent(event);
        },
        child: const Icon(Icons.save),
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.only(left: 16, top: 48, right: 16, bottom: 16),
        color: Color(vm.color),
        child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: noteColors
                    .map((color) => InkWell(
                        onTap: () {
                          vm.onEvent(AddEditNoteEvent.changeColor(color.value));
                        },
                        child: _buildBackgroundColor(
                          color: color,
                          selected: color.value == vm.color,
                        )))
                    .toList()),
            TextField(
              controller: _titleController,
              maxLines: 1,
              style: Theme.of(context).textTheme.headline5!.copyWith(color: darkGray),
              decoration: const InputDecoration(hintText: '제목을 입력하세요', border: InputBorder.none),
            ),
            TextField(
              controller: _contentController,
              maxLines: null,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(color: darkGray),
              decoration: const InputDecoration(hintText: '내용을 입력하세요', border: InputBorder.none),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundColor({required Color color, required bool selected}) {
    return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5.0, spreadRadius: 1.0)],
          border: selected ? Border.all(color: Colors.black, width: 3) : null,
        ));
  }
}
