import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/core/errors/exceptions.dart';
import 'package:task_manager/data/model/todo_model.dart';
import 'package:task_manager/data/repository/todo_repository/todo_repository.dart';

class FirebaseTodoRepository implements TodoRepository {
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;

  String _getUserId() {
    final user = _auth.currentUser;
    if (user == null) {
      throw UserNotLoggedInException();
    }
    return user.uid;
  }

  @override
  Future<String> addTodo(String cid, Map<String, dynamic> map) async {
    final userId = _getUserId();

    try {
      final docRef =
          _store
              .collection('users')
              .doc(userId)
              .collection('categories')
              .doc(cid)
              .collection('todos')
              .doc();
      await _store
          .collection('users')
          .doc(userId)
          .collection('categories')
          .doc(cid)
          .collection('todos')
          .doc(docRef.id)
          .set({'id': docRef.id}..addAll(map));
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add todo.');
    }
  }

  @override
  Future<void> deleteTodo(String cid, String tid) async {
    final userId = _getUserId();
    try {
      await _store
          .collection('users')
          .doc(userId)
          .collection('categories')
          .doc(cid)
          .collection('todos')
          .doc(tid)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete todo.');
    }
  }

  @override
  Future<void> updateTodo(String cid, TodoModel todo) async {
    final userId = _getUserId();
    try {
      await _store
          .collection('users')
          .doc(userId)
          .collection('categories')
          .doc(cid)
          .collection('todos')
          .doc(todo.id)
          .update(todo.toMap());
    } catch (e) {
      throw Exception('Failed to update category.');
    }
  }

  @override
  Future<Map<String, dynamic>> findById(String cid, String tid) async {
    final userId = _getUserId();
    try {
      final docSnapshot =
          await _store
              .collection('users')
              .doc(userId)
              .collection('categories')
              .doc(cid)
              .collection('todos')
              .doc(tid)
              .get();

      if (docSnapshot.exists) {
        return docSnapshot.data()!;
      } else {
        throw Exception('Todo not found');
      }
    } catch (e) {
      throw Exception('Failed to find todo by id: $e');
    }
  }
}
