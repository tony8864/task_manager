import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/bloc/todo_bloc/todo_bloc.dart';
import 'package:task_manager/data/model/todo_model.dart';
import 'package:task_manager/data/repository/auth_repository/firebase_auth_repository.dart';
import 'package:task_manager/data/repository/category_repository.dart/category_repository.dart';
import 'package:task_manager/data/repository/category_repository.dart/firebase_category_repository.dart';
import 'package:task_manager/data/repository/todo_repository/firebase_todo_repository.dart';
import 'package:task_manager/data/repository/todo_repository/todo_repository.dart';
import 'package:task_manager/firebase_options.dart';

void main() {
  group('test todo bloc', () {
    late FirebaseFirestore firestore;
    late FirebaseAuth firebaseAuth;
    late FirebaseAuthRepository authRepository;
    late CategoryRepository categoryRepository;
    late TodoRepository todoRepository;
    late TodoBloc todoBloc;
    late Map<String, dynamic> userModelMap;
    late Map<String, dynamic> categoryModelMap;
    late Map<String, dynamic> todoModelMap;

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
      authRepository = FirebaseAuthRepository();
      categoryRepository = FirebaseCategoryRepository();
      todoRepository = FirebaseTodoRepository();
      todoBloc = TodoBloc();
      userModelMap = {'name': 'tony', 'email': 'tony@email.com'};
      categoryModelMap = {'name': 'work'};
      todoModelMap = {
        'title': 'code',
        'time':'12:00',
        'description': 'learn python',
        'isCompleted': false,
        'dueDate': 'today',
      };
    });

    group('test update todo', () {
      blocTest(
        'should emit TodoSuccess when updating todo',
        build: () => todoBloc,
        setUp: () async => await authRepository.register(userModelMap, 'test123', 'test123'),
        act: (bloc) async {
          final cid = await categoryRepository.addCategory(categoryModelMap);
          final tid = await todoRepository.addTodo(cid, todoModelMap);
          bloc.add(UpdateTodoEvent(cid, TodoModel.fromMap(todoModelMap..addAll({'id': tid}))));
        },
        wait: const Duration(milliseconds: 2000),
        expect: () => [isA<TodoLoading>(), isA<TodoSuccess>()],
        tearDown: () async => await clearFirebase(),
      );

      blocTest(
        'should emit TodoFailure when updating todo',
        build: () => todoBloc,
        act: (bloc) async {
          bloc.add(UpdateTodoEvent('xxx', TodoModel.fromMap(todoModelMap..addAll({'id': '1'}))));
        },
        wait: const Duration(milliseconds: 2000),
        expect: () => [isA<TodoLoading>(), isA<TodoFailure>()],
      );
    });

    group('test delete todo', () {
      blocTest(
        'should emit TodoSuccess when deleting todo',
        build: () => todoBloc,
        setUp: () async => await authRepository.register(userModelMap, 'test123', 'test123'),
        act: (bloc) async {
          final cid = await categoryRepository.addCategory(categoryModelMap);
          final tid = await todoRepository.addTodo(cid, todoModelMap);
          bloc.add(DeleteTodoEvent(cid, tid));
        },
        wait: const Duration(milliseconds: 2000),
        expect: () => [isA<TodoLoading>(), isA<TodoSuccess>()],
        tearDown: () async => await clearFirebase(),
      );

      blocTest(
        'should emit TodoFailure when deleting todo',
        build: () => todoBloc,
        act: (bloc) async {
          bloc.add(DeleteTodoEvent('xxx', 'xxx'));
        },
        wait: const Duration(milliseconds: 2000),
        expect: () => [isA<TodoLoading>(), isA<TodoFailure>()],
      );
    });

    group('test add todo', () {
      blocTest(
        'should emit TodoSuccess when adding todo',
        build: () => todoBloc,
        setUp: () async => await authRepository.register(userModelMap, 'test123', 'test123'),
        act: (bloc) async {
          final cid = await categoryRepository.addCategory(categoryModelMap);
          bloc.add(AddTodoEvent(cid, todoModelMap));
        },
        wait: const Duration(milliseconds: 2000),
        expect: () => [isA<TodoLoading>(), isA<TodoSuccess>()],
        tearDown: () async => await clearFirebase(),
      );

      blocTest(
        'should emit TodoFailure when adding todo',
        build: () => todoBloc,
        act: (bloc) async {
          bloc.add(AddTodoEvent('xxx', todoModelMap));
        },
        wait: const Duration(milliseconds: 2000),
        expect: () => [isA<TodoLoading>(), isA<TodoFailure>()],
      );
    });
  });
}
