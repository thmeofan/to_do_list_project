import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_project/constants/text_styles.dart';

import '../bLoc/todo_list_bloc.dart';
import '../bLoc/todo_list_event.dart';
import '../constants/screens.dart';
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
                        widget.toDoNote.isChecked = !widget.toDoNote.isChecked;
                        context
                            .read<ToDoListBloc>()
                            .add(ChangeToDoEvent(widget.toDoNote));
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    Expanded(
                      child: Text(
                        widget.toDoNote.text,
                        style: AppTextStyles.toDoNoteStyle,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        context
                            .read<ToDoListBloc>()
                            .add(DeleteToDoEvent(widget.toDoNote));
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
