import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list_project/class_repository/todo_repository.dart';

import '../bLoc/todo_list_bloc.dart';
import '../bLoc/todo_list_event.dart';
import '../bLoc/todo_list_state.dart';
import '../constants/screens.dart';
import '../main.dart';
import '../models/todo_list_model.dart';
import '../widgets/todo_list_widget.dart';

class ToDoListsScreen extends StatefulWidget {
  ToDoListsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ToDoListsScreen> createState() => _ToDoScreenState();
}

enum Menu { delete }

class _ToDoScreenState extends State<ToDoListsScreen> {
  String _selectedMenu = '';

  // Future<void> deleteAllToDoNotes() async {
  //   var box = await Hive.openBox(notesKeeperKey);
  //   List<ToDoModel> toDosList = box.get(notesListKey).cast<ToDoModel>();
  //   toDosList.clear();
  //
  //   await box.put(notesListKey, toDosList);
  //   await box.close();
  // }
  //
  // CollectionReference todos = FirebaseFirestore.instance.collection('todos');
  //
  // Future<void> batchDelete() {
  //   WriteBatch batch = FirebaseFirestore.instance.batch();
  //
  //   return todos.get().then((querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       batch.delete(doc.reference);
  //     });
  //
  //     return batch.commit();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(228, 230, 195, 1),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(137, 152, 120, 1),
        heroTag: "btn1",
        onPressed: () {
          Navigator.pushNamed(context, Screens.createToDo);
        },
        child: const Icon(Icons.create_outlined),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(137, 152, 120, 1),
        title: const Text("To Do List"),
        actions: [
          PopupMenuButton(
              onSelected: (Menu item) {
                setState(() {
                  _selectedMenu = item.name;
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                    PopupMenuItem(
                        value: Menu.delete,
                        child: Text('Delete all'),
                        onTap: () {

                          context
                              .read<ToDoListBloc>()
                              .add(DeleteAllToDoEvent());
                        }),
                  ]),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: BlocBuilder<ToDoListBloc, ToDoListState>(
                  builder: (context, state) {
                if (state is LoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is EmptyState) {
                  return Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: const Color.fromRGBO(137, 152, 120, 1),
                      ),
                      padding: const EdgeInsets.all(25),
                      margin: const EdgeInsets.fromLTRB(50, 55, 50, 70),
                      child: const Center(child: Text('Empty')));
                } else if (state is ToDoListDataState) {
                  List<Widget> noteWidgets = [];

                  for (int index = 0; index < state.notes.length; index++) {
                    noteWidgets.add(ToDoListWidget(
                      toDoNote: state.notes[index],
                    ));
                  }
                  return Container(
                    color: const Color.fromRGBO(137, 152, 120, 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: noteWidgets,
                    ),
                  );
                } else {
                  return Container();
                }
              }),
            ),
          ),
          // FloatingActionButton(
          //   heroTag: "btn2",
          //   onPressed: () {
          //     context.read<ToDoListBloc>().add(DeleteAllToDoEvent());
          //     deleteAllToDoNotes();
          //   },
          //   backgroundColor: const Color.fromRGBO(137, 152, 120, 1),
          //   //foregroundColor: Colors.black87,
          //   child: const Icon(Icons.delete_forever),
          // ),
        ],
      ),
    );
  }
}
