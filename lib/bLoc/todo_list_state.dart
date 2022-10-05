import '../models/todo_list_model.dart';

class ToDoListState {}

class ToDoListDataState extends ToDoListState {
  final List<ToDoModel> notes;

  ToDoListDataState(this.notes);
}

class EmptyState extends ToDoListState {}

class LoadingState extends ToDoListState {}

class IsCheckedState extends ToDoListState{

}