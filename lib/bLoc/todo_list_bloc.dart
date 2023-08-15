import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_project/bLoc/todo_list_event.dart';
import 'package:to_do_list_project/bLoc/todo_list_state.dart';
import 'package:to_do_list_project/class_repository/notification_service.dart';
import 'package:to_do_list_project/class_repository/todo_repository.dart';

import '../models/todo_list_model.dart';

class ToDoListBloc extends Bloc<ToDoListEvent, ToDoListState> {
  ToDoListBloc() : super(LoadingState()) {
    on<SaveToDoEvent>(_onSaveNote);
    on<DeleteToDoEvent>(_onDeleteNote);
    on<DeleteAllToDoEvent>(_onDeleteAllNotes);
    on<EmptyListEvent>(_onEmptyList);
    on<ChangeToDoEvent>(_onChangeNote);
    on<UpdateToDoEvent>(_onUpdateToDo);
    ToDoRepository().collection.snapshots().listen((event) {
      List<ToDoModel> _toDoNotes = [];
      for (var doc in event.docs) {
        ToDoModel toDo = ToDoModel.fromJson(doc.data() as Map<String, dynamic>);
        _toDoNotes.add(toDo);
      }
      this.add(UpdateToDoEvent(_toDoNotes));
      ToDoRepository().saveToHive(_toDoNotes);
    });
  }

  void _onSaveNote(SaveToDoEvent event, Emitter<ToDoListState> emit) {
    ToDoRepository().saveToFirebase(event.toDoNote);
   // FirebaseMessaging.onBackgroundMessage(backgroundMassageHandler);
    NotificationService().sendPush();
    NotificationService().foregroundMessage();

  }

  void _onDeleteNote(DeleteToDoEvent event, Emitter<ToDoListState> emit) {
    ToDoRepository().deleteFromFirebase(event.note);
    ToDoRepository().deleteFromHive(event.note);
    //  }
  }

  void _onDeleteAllNotes(
      DeleteAllToDoEvent event, Emitter<ToDoListState> emit) {
    //  _toDoNotes.clear();
    ToDoRepository().deleteAllFromHive();
    ToDoRepository().deleteAllFromFirebase();
    emit(EmptyState());
  }

  void _onUpdateToDo(UpdateToDoEvent event, Emitter<ToDoListState> emit) {
    if (event.toDosList.isEmpty) {
      emit(EmptyState());
    } else {
      emit(ToDoListDataState(event.toDosList));
    }
  }

  void _onEmptyList(EmptyListEvent event, Emitter<ToDoListState> emit) {
    emit(EmptyState());
  }

  void _onChangeNote(ChangeToDoEvent event, Emitter<ToDoListState> emit) {
    // _notes[_notes.indexOf(event.note)]= event.note;

    ToDoRepository().editInFirebase(event.note);
    ToDoRepository().editInHive(event.note);
  }
}
