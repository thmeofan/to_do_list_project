import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unicons/unicons.dart';

import '../bLoc/todo_list_bloc.dart';
import '../bLoc/todo_list_event.dart';
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


  Random random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(228, 230, 195, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(137, 152, 120, 1),
        title: const Text("Create"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: Color.fromRGBO(137, 152, 120, 1),
            ),
            width: double.maxFinite,
            margin: const EdgeInsets.all(30),
            padding: const EdgeInsets.all(15),
            child: TextField(
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
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
                  ToDoModel toDoNote = ToDoModel(myController.text,
                      random.nextInt(1 << 32).toString(), false);
                  context.read<ToDoListBloc>().add(SaveToDoEvent(toDoNote));
                  FocusScope.of(context).unfocus();
                  Navigator.of(context).pop();
                  myController.clear();
                },
                backgroundColor: Color.fromRGBO(137, 152, 120, 1),
                child: const Icon(UniconsLine.notes),
              ),
            ],
          )
        ], // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
