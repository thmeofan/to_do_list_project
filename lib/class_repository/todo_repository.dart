import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list_project/main.dart';

import '../models/todo_list_model.dart';

class ToDoRepository {
  static final ToDoRepository _toDoRepository = ToDoRepository._internal();

  ToDoRepository._internal();

  factory ToDoRepository() {
    return _toDoRepository;
  }

  CollectionReference collection =
      FirebaseFirestore.instance.collection("todos");

  Future<void> saveToFirebase(ToDoModel toDoNote) async {
    FirebaseFirestore.instance
        .collection("todos")
        .doc(toDoNote.id)
        .set(toDoNote.toJson());
  }

  Future<void> saveToHive(List<ToDoModel> toDoNotes) async {
    var box = await Hive.openBox(notesKeeperKey);
    List<ToDoModel> notesList =
        box.get(notesListKey, defaultValue: []).cast<ToDoModel>();
    notesList.addAll(toDoNotes);

    await box.put(notesListKey, notesList);
    await box.close();
  }

  Future<void> editInFirebase(ToDoModel toDoNote) async {
    FirebaseFirestore.instance
        .collection("todos")
        .doc(toDoNote.id)
        .set(toDoNote.toJson());
  }

  Future<void> editInHive(ToDoModel newNote) async {
    var box = await Hive.openBox(notesKeeperKey);
    List<ToDoModel> notesList = box.get(notesListKey).cast<ToDoModel>();
    ToDoModel theNote =
        notesList.firstWhere((element) => element.id == newNote.id);
    int indexOfTheNote = notesList.indexOf(theNote);
    notesList[indexOfTheNote] = newNote;
    await box.put(notesListKey, notesList);
    await box.close();
  }

  // Future<void> isCheckedForFirebase(ToDoModel theNote) async {
  //   FirebaseFirestore.instance
  //       .collection("todos")
  //       .doc(theNote.id)
  //       .set(theNote.toJson());
  // }

  // Future<void> isCheckedForHive(ToDoModel toDoNote) async {
  //   var box = await Hive.openBox(notesKeeperKey);
  //   List<ToDoModel> notesList = box.get(notesListKey).cast<ToDoModel>();
  //   ToDoModel theNote =
  //       notesList.firstWhere((element) => element.id == toDoNote.id);
  //   int indexOfTheNote = notesList.indexOf(theNote);
  //   notesList[indexOfTheNote].isChecked = !notesList[indexOfTheNote].isChecked;
  //   await box.put(notesListKey, notesList);
  //   await box.close();
  // }

  Future<void> deleteFromFirebase(ToDoModel note) async {
    FirebaseFirestore.instance.collection("todos").doc(note.id).delete();
  }

  Future<void> deleteFromHive(ToDoModel note) async {
    var box = await Hive.openBox(notesKeeperKey);
    List<ToDoModel> notesList = box.get(notesListKey).cast<ToDoModel>();
    notesList.remove(note);

    await box.put(notesListKey, notesList);
    await box.close();
  }

  Future<void> deleteAllFromFirebase() {
    CollectionReference todos = FirebaseFirestore.instance.collection('todos');
    WriteBatch batch = FirebaseFirestore.instance.batch();

    return todos.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        batch.delete(doc.reference);
      });

      return batch.commit();
    });
  }

  Future<void> deleteAllFromHive() async {
    var box = await Hive.openBox(notesKeeperKey);
    List<ToDoModel> toDosList = box.get(notesListKey).cast<ToDoModel>();
    toDosList.clear();

    await box.put(notesListKey, toDosList);
    await box.close();
  }
}
