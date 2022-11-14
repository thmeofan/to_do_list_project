import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unicons/unicons.dart';

import '../bLoc/todo_list_bloc.dart';
import '../bLoc/todo_list_event.dart';
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
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
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
                  FocusScope.of(context).unfocus();
                  Navigator.of(context).pop();
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
