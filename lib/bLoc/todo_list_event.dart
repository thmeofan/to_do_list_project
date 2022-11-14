import 'package:to_do_list_project/models/todo_list_model.dart';

class ToDoListEvent {}

class SaveToDoEvent extends ToDoListEvent {
  final ToDoModel toDoNote;

  SaveToDoEvent(this.toDoNote);
}

class DeleteToDoEvent extends ToDoListEvent {
  final ToDoModel note;

  DeleteToDoEvent(this.note);
}

class DeleteAllToDoEvent extends ToDoListEvent {
  DeleteAllToDoEvent();
}

class EmptyListEvent extends ToDoListEvent {}

class ChangeToDoEvent extends ToDoListEvent {
  final ToDoModel note;

  ChangeToDoEvent(this.note);
}

class IsCheckedEvent extends ToDoListEvent {
  final ToDoModel note;

  IsCheckedEvent(this.note);
}

class UpdateToDoEvent extends ToDoListEvent {
  final List<ToDoModel> toDosList;

  UpdateToDoEvent(this.toDosList);
}
