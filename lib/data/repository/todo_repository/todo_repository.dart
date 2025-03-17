import 'package:task_manager/data/model/todo_model.dart';

abstract class TodoRepository {
  Future<String> addTodo(String cid, Map<String, dynamic> map);
  Future<void> deleteTodo(String cid, String tid);
  Future<void> updateTodo(String cid, TodoModel todo);
}