import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list_project/constants/text_styles.dart';

import '../bLoc/todo_list_bloc.dart';
import '../bLoc/todo_list_event.dart';
import '../constants/screens.dart';
import '../main.dart';
import '../models/todo_list_model.dart';

Icon checkMark = Icon(Icons.square_outlined);

class ToDoListWidget extends StatefulWidget {
  final ToDoModel toDoNote;

  const ToDoListWidget({super.key, required this.toDoNote});

  @override
  State<ToDoListWidget> createState() => _ToDoListWidgetState();
}

class _ToDoListWidgetState extends State<ToDoListWidget> {
  bool isChecked = false;

  Future<void> deleteNote(ToDoModel note) async {
    var box = await Hive.openBox(notesKeeperKey);
    List<ToDoModel> notesList = box.get(notesListKey).cast<ToDoModel>();
    notesList.remove(note);

    await box.put(notesListKey, notesList);
    await box.close();
  }

  Future<void> isCheckedFunction() async {
    var box = await Hive.openBox(notesKeeperKey);
    List<ToDoModel> notesList = box.get(notesListKey).cast<ToDoModel>();
    ToDoModel theNote =
        notesList.firstWhere((element) => element.id == widget.toDoNote.id);
    int indexOfTheNote = notesList.indexOf(theNote);
    notesList[indexOfTheNote].isChecked = !notesList[indexOfTheNote].isChecked;
    FirebaseFirestore.instance
        .collection("todos")
        .doc(theNote.id)
        .set(theNote.toJson());
    await box.put(notesListKey, notesList);
    await box.close();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //  color: Colors.grey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            // color: const Color.fromRGBO(228, 230, 195, 1),

            width: double.maxFinite,
            margin: const EdgeInsets.all(15),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Screens.editToDo,
                    arguments: widget.toDoNote);
              },
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: Color.fromRGBO(228, 230, 195, 1),
                ),
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: widget.toDoNote.isChecked,
                      activeColor: Color.fromRGBO(228, 230, 195, 1),
                      checkColor: Color.fromRGBO(137, 152, 120, 1),
                      onChanged: (bool? value) {
                        setState(() {
                          context
                              .read<ToDoListBloc>()
                              .add(IsCheckedEvent(widget.toDoNote));
                          isCheckedFunction();
                        });
                      },
                    ),
                    Text(
                      widget.toDoNote.text,
                      style: AppTextStyles.toDoNoteStyle,
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () async {
                        context
                            .read<ToDoListBloc>()
                            .add(DeleteToDoEvent(widget.toDoNote));
                        deleteNote(widget.toDoNote);

                        FirebaseFirestore.instance
                            .collection("todos")
                            .doc(widget.toDoNote.id)
                            .delete();

                        FocusScope.of(context).unfocus();
                      },
                      iconSize: 35,
                      tooltip: 'Increment',
                      color: Color.fromRGBO(137, 152, 120, 1),
                      icon: const Icon(Icons.dangerous_outlined),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
