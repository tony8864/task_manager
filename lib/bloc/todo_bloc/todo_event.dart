part of 'todo_bloc.dart';

sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

final class TodoSubscriptionEvent extends TodoEvent {
  final String cid;

  const TodoSubscriptionEvent(this.cid);

  @override
  List<Object> get props => [cid];
}

final class AddTodoEvent extends TodoEvent {
  final String cid;
  final Map<String, dynamic> todoMap;

  const AddTodoEvent(this.cid, this.todoMap);

  @override
  List<Object> get props => [todoMap];
}

final class DeleteTodoEvent extends TodoEvent {
  final String cid;
  final String tid;

  const DeleteTodoEvent(this.cid, this.tid);

  @override
  List<Object> get props => [tid];
}

final class UpdateTodoEvent extends TodoEvent {
  final String cid;
  final TodoModel todoModel;

  const UpdateTodoEvent(this.cid, this.todoModel);

  @override
  List<Object> get props => [todoModel];
}
