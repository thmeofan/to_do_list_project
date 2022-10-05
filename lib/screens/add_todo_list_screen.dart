import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../bLoc/todo_list_bloc.dart';
import '../bLoc/todo_list_event.dart';
import '../main.dart';
import '../models/todo_list_model.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  Future<void> saveToDoNote(ToDoModel note) async {
    var box = await Hive.openBox(notesKeeperKey);
    List<ToDoModel> notesList = box.get(notesListKey,defaultValue: []).cast<ToDoModel>();
    notesList.add(note);

    await box.put(notesListKey, notesList);
    await box.close();
  }

  Random random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(228,230,195,1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(137,152,120,1),
        title: const Text("Create"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Color.fromRGBO(137,152,120,1),
          ),
            width: double.maxFinite,
            margin: const EdgeInsets.all(30),
            padding: const EdgeInsets.all(15),
            child: TextField(
              cursorColor: Colors.white,
              controller: myController,
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                heroTag: "btn3",
                onPressed: () {
                  ToDoModel toDoNote = ToDoModel(myController.text, random.nextInt(1 << 32).toString(), false);
                  context.read<ToDoListBloc>().add(SaveToDoEvent(toDoNote));
                  myController.clear();
                  FirebaseFirestore.instance.collection("todos").doc(toDoNote.id).set(toDoNote.toJson());
                  saveToDoNote(toDoNote);
                  FocusScope.of(context).unfocus();
                  Navigator.of(context).pop();
                },
                backgroundColor: Color.fromRGBO(137,152,120,1),
                child: const Icon(Icons.save_as_outlined),
              ),
            ],
          )
        ], // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}