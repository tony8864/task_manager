import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:task_manager/data/model/todo_model.dart';
import 'package:task_manager/data/repository/todo_repository/firebase_todo_repository.dart';
import 'package:task_manager/data/repository/todo_repository/todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository _todoRepository = GetIt.instance<FirebaseTodoRepository>();

  TodoBloc() : super(TodoInitial()) {
    on<AddTodoEvent>(_onAddTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
    on<UpdateTodoEvent>(_onUpdateTodo);
  }

  Future<void> _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    try {
      emit(TodoLoading());
      await _todoRepository.addTodo(event.cid, event.todoMap);
      emit(TodoSuccess());
    } on Exception {
      emit(TodoFailure());
    }
  }

  Future<void> _onDeleteTodo(DeleteTodoEvent event, Emitter<TodoState> emit) async {
    try {
      emit(TodoLoading());
      await _todoRepository.deleteTodo(event.cid, event.tid);
      emit(TodoSuccess());
    } on Exception {
      emit(TodoFailure());
    }
  }

  Future<void> _onUpdateTodo(UpdateTodoEvent event, Emitter<TodoState> emit) async {
    try {
      emit(TodoLoading());
      await _todoRepository.updateTodo(event.cid, event.todoModel);
      emit(TodoSuccess());
    } on Exception {
      emit(TodoFailure());
    }
  }
}
