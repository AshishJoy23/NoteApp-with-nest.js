import 'package:flutter/material.dart';
import 'package:note_app_with_nest/data/data.dart';
import 'package:note_app_with_nest/data/note_model/note_model.dart';

enum ActionType {
  addNote,
  editNote,
}

class ScreenAddNote extends StatelessWidget {
  final ActionType type;
  String? id;

  ScreenAddNote({
    Key? key,
    required this.type,
    this.id,
  }) : super(key: key);

  Widget get saveButton => TextButton.icon(
      onPressed: () {
        switch (type) {
          case ActionType.addNote:
            //add note
            saveNote();
            break;
          case ActionType.editNote:
            //edit note
            saveEditedNote();
            break;
          default:
        }
      },
      icon: const Icon(
        Icons.save,
        color: Colors.white,
      ),
      label: const Text(
        'Save',
        style: TextStyle(color: Colors.white),
      )
    );

    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    if (type==ActionType.editNote) {
      if (id==null) {
        Navigator.of(context).pop();
      }

      final note = NoteDB.instance.getNoteByID(id!);
      if(note==null){
        Navigator.of(context).pop();
      }

      titleController.text = note!.title ?? 'No Title';
      contentController.text = note.content ?? 'No Content';
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          type.name.toUpperCase(),
        ),
        actions: [
          saveButton,
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Title',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: contentController,
              maxLines: 5,
              maxLength: 100,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Content',
              ),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> saveNote() async{
    final title = titleController.text;
    final content = contentController.text;

    final savedNote = NoteModel.create(
      id: DateTime.now().microsecondsSinceEpoch.toString(), 
      title: title, 
      content: content
    );

    final newNote = NoteDB().createNote(savedNote);
    if (newNote!= null) {
      print('Note Saved');
      Navigator.of(scaffoldKey.currentContext!).pop();
    } else {
      print('Error while Saving');
    }

  }
  
  Future<void> saveEditedNote() async{
    final title = titleController.text;
    final content = contentController.text;

    final editedNote = NoteModel.create(
      id: id, 
      title: title, 
      content: content
    ); 

    final note = await NoteDB.instance.updateNote(editedNote);
    if (note==null) {
      print('Unable to update note');
    }else{
      Navigator.of(scaffoldKey.currentContext!).pop();
    }
  }
}
