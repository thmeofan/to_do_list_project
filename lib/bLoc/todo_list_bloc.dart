

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_project/bLoc/todo_list_event.dart';
import 'package:to_do_list_project/bLoc/todo_list_state.dart';

import '../models/todo_list_model.dart';

class ToDoListBloc extends Bloc<ToDoListEvent, ToDoListState> {
  List<ToDoModel> _toDoNotes = [];

  ToDoListBloc() : super(LoadingState()) {
    on<SaveToDoEvent>(_onSaveNote);
    on<DeleteToDoEvent>(_onDeleteNote);
    on<DeleteAllToDoEvent>(_onDeleteAllNotes);
    on<EmptyListEvent>(_onEmptyList);
    on<ChangeToDoEvent>(_onChangeNote);
    on<IsCheckedEvent>(_onIsChecked);
  }


  void _onSaveNote(SaveToDoEvent event, Emitter<ToDoListState> emit) {
    _toDoNotes.add(event.toDoNote);
    emit(ToDoListDataState(_toDoNotes));
  }

  void _onDeleteNote(DeleteToDoEvent event, Emitter<ToDoListState> emit) {
    _toDoNotes.remove(event.note);
    if (_toDoNotes.isEmpty) {
      emit(EmptyState());
    } else {
      emit(ToDoListDataState(_toDoNotes));
    }
  }

  void _onDeleteAllNotes(DeleteAllToDoEvent event, Emitter<ToDoListState> emit) {
    _toDoNotes.clear();
    emit(EmptyState());
  }

  void _onEmptyList(EmptyListEvent event, Emitter<ToDoListState> emit) {
    emit(EmptyState());
  }

  void _onChangeNote(ChangeToDoEvent event, Emitter<ToDoListState> emit) {
    // _notes[_notes.indexOf(event.note)]= event.note;
    ToDoModel theNote=_toDoNotes.firstWhere((element)=> element.id==event.note.id);
    int indexOfTheNote=_toDoNotes.indexOf(theNote);
    _toDoNotes[indexOfTheNote]=event.note;
    emit(ToDoListDataState(_toDoNotes));
  }

void _onIsChecked (IsCheckedEvent event,Emitter<ToDoListState> emit ){
    int indexOfNote=_toDoNotes.indexOf(event.note);
    _toDoNotes[indexOfNote].isChecked=!_toDoNotes[indexOfNote].isChecked;

  emit(ToDoListDataState(_toDoNotes));

}
}
