import 'package:flutter/material.dart';
import 'package:flutter_note_app/domain/model/note.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({Key? key, required this.note, this.onDeleteClick}) : super(key: key);

  final Note note;
  final Function? onDeleteClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(note.color)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 16),
                Text(
                  note.content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText2,
                )
              ],
            ),
          ),
          Positioned(
              bottom: 8,
              right: 8,
              child: GestureDetector(
                child: const Icon(Icons.delete),
                onTap: () {
                  onDeleteClick?.call();
                },
              ))
        ],
      ),
    );
  }
}
