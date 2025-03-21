import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/data/model/todo_model.dart';
import 'package:task_manager/data/repository/auth_repository/auth_repository.dart';
import 'package:task_manager/data/repository/auth_repository/firebase_auth_repository.dart';
import 'package:task_manager/data/repository/category_repository.dart/category_repository.dart';
import 'package:task_manager/data/repository/category_repository.dart/firebase_category_repository.dart';
import 'package:task_manager/data/repository/todo_repository/firebase_todo_repository.dart';
import 'package:task_manager/data/repository/todo_repository/todo_repository.dart';
import 'package:task_manager/firebase_options.dart';

void main() {
  group('test todo repository', () {
    late FirebaseFirestore firestore;
    late FirebaseAuth firebaseAuth;
    late AuthRepository authRepository;
    late TodoRepository todoRepository;
    late CategoryRepository categoryRepository;

    Future<void> clearFirebase() async {
      var user = firebaseAuth.currentUser;
      var categories = firestore.collection('users').doc(user?.uid).collection('categories');
      var snapshots = await categories.get();
      for (var doc in snapshots.docs) {
        var categoryRef = doc.reference;
        var todos = await categoryRef.collection('todos').get();
        for (var todo in todos.docs) {
          await todo.reference.delete();
        }
        await doc.reference.delete();
      }
      await firestore.collection('users').doc(user?.uid).delete();
      await user?.delete();
    }

    setUpAll(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    });

    setUp(() {
      firestore = FirebaseFirestore.instance;
      firebaseAuth = FirebaseAuth.instance;
      firestore.useFirestoreEmulator('localhost', 8080);
      firebaseAuth.useAuthEmulator('localhost', 9099);
      todoRepository = FirebaseTodoRepository();
      categoryRepository = FirebaseCategoryRepository();
      authRepository = FirebaseAuthRepository();
    });

    group('test add todo', () {
      test('should add new todo', () async {
        await authRepository.register(
          {'name': 'tony', 'email': 'tony@email.com'},
          'test123',
          'test123',
        );
        String cid = await categoryRepository.addCategory({'name': 'work'});
        String tid = await todoRepository.addTodo(cid, {'title': 'work', 'isCompleted': false});
        final storedTodoRef = firestore
            .collection('users')
            .doc((firebaseAuth.currentUser?.uid))
            .collection('categories')
            .doc(cid)
            .collection('todos')
            .doc(tid);
        final storedTodoSnap = await storedTodoRef.get();
        final storedTodo = storedTodoSnap.data();
        expect(storedTodo!['title'], 'work');
        expect(storedTodo['isCompleted'], false);
        await clearFirebase();
      });
    });

    group('test delete todo', () {
      test('should delete todo', () async {
        await authRepository.register(
          {'name': 'tony', 'email': 'tony@email.com'},
          'test123',
          'test123',
        );
        String cid = await categoryRepository.addCategory({'name': 'work'});
        String tid = await todoRepository.addTodo(cid, {'title': 'work', 'isCompleted': false});
        final todosRef = firestore
            .collection('users')
            .doc((firebaseAuth.currentUser?.uid))
            .collection('categories')
            .doc(cid)
            .collection('todos');
        var result = await todosRef.where('title', isEqualTo: 'work').get();
        expect(result.docs.length, 1);
        await todoRepository.deleteTodo(cid, tid);
        result = await todosRef.where('title', isEqualTo: 'work').get();
        expect(result.docs.length, 0);
        await clearFirebase();
      });
    });

    group('test update todo', () {
      test('should update todo', () async {
        await authRepository.register(
          {'name': 'tony', 'email': 'tony@email.com'},
          'test123',
          'test123',
        );
        String cid = await categoryRepository.addCategory({'name': 'work'});
        String tid = await todoRepository.addTodo(cid, {'title': 'work', 'isCompleted': false});
        final todosRef = firestore
            .collection('users')
            .doc((firebaseAuth.currentUser?.uid))
            .collection('categories')
            .doc(cid)
            .collection('todos');
        var result = await todosRef.where('title', isEqualTo: 'work').get();
        expect(result.docs.length, 1);
        await todoRepository.updateTodo(
          cid,
          TodoModel.fromMap({
            'id': tid,
            'title': 'code',
            'time':'12:00',
            'description': 'learn java',
            'isCompleted': false,
            'dueDate': 'today',
          }),
        );
        final docSnap = await todosRef.doc(tid).get();
        final docData = docSnap.data();
        expect(docData, {
          'id': tid,
          'title': 'code',
          'time':'12:00',
          'description': 'learn java',
          'isCompleted': false,
          'dueDate': 'today',
        });
        await clearFirebase();
      });
    });
  });
}
