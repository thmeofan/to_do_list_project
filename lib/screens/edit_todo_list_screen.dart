import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../bLoc/todo_list_bloc.dart';
import '../bLoc/todo_list_event.dart';
import '../main.dart';
import '../models/todo_list_model.dart';

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({super.key});

  @override
  State<StatefulWidget> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late final TextEditingController myController;

  @override
  void initState() {
    myController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  Future<void> editNote(ToDoModel newNote) async {
    var box = await Hive.openBox(notesKeeperKey);
    List<ToDoModel> notesList = box.get(notesListKey).cast<ToDoModel>();
    ToDoModel theNote =
        notesList.firstWhere((element) => element.id == newNote.id);
    int indexOfTheNote = notesList.indexOf(theNote);
    notesList[indexOfTheNote] = newNote;
    await box.put(notesListKey, notesList);
    await box.close();
  }

  @override
  Widget build(BuildContext context) {
    final ToDoModel toDoNote =
        ModalRoute.of(context)?.settings.arguments! as ToDoModel;
    myController.text = toDoNote.text;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(137, 152, 120, 1),
        title: const Text("Edit"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextField(
            controller: myController,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                heroTag: "btn4",
                onPressed: () {
                  ToDoModel newNote =
                      ToDoModel(myController.text, toDoNote.id, false);
                  context.read<ToDoListBloc>().add(ChangeToDoEvent(newNote));
                  editNote(newNote);
                  FocusScope.of(context).unfocus();
                  Navigator.of(context).pop();
                  FirebaseFirestore.instance
                      .collection("todos")
                      .doc(newNote.id)
                      .set(newNote.toJson());
                },
                backgroundColor: Color.fromRGBO(137, 152, 120, 1),
                child: const Icon(Icons.save_as_outlined),
              ),
            ],
          )
        ], // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
