part of 'todo_bloc.dart';

sealed class TodoState extends Equatable {
  const TodoState();
  
  @override
  List<Object> get props => [];
}

final class TodoInitial extends TodoState {}

final class TodoLoading extends TodoState {}

final class TodoSuccess extends TodoState {}

final class TodoFailure extends TodoState {}

final class TodosFetched extends TodoState {
  final List<TodoModel> todos;

  const TodosFetched({required this.todos});

  @override
  List<Object> get props => [todos];
}