import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/core/errors/exceptions.dart';
import 'package:task_manager/data/model/category_model.dart';
import 'package:task_manager/data/repository/auth_repository/auth_repository.dart';
import 'package:task_manager/data/repository/auth_repository/firebase_auth_repository.dart';
import 'package:task_manager/data/repository/category_repository.dart/category_repository.dart';
import 'package:task_manager/data/repository/category_repository.dart/firebase_category_repository.dart';
import 'package:task_manager/firebase_options.dart';

void main() {
  group('test collection repository', () {
    late FirebaseFirestore firestore;
    late FirebaseAuth firebaseAuth;
    late AuthRepository authRepository;
    late CategoryRepository categoryRepository;

    Future<void> clearFirebase() async {
      final user = firebaseAuth.currentUser;
      final collection = firestore.collection('users').doc(user?.uid).collection('categories');
      final snapshots = await collection.get();
      for (var doc in snapshots.docs) {
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
      categoryRepository = FirebaseCategoryRepository();
      authRepository = FirebaseAuthRepository();
    });

    group('test update category', () {
      test('should update category', () async {
        await authRepository.register(
          {'name': 'tony', 'email': 'tony@email.com'},
          'test123',
          'test123',
        );
        await categoryRepository.addCategory({'name': 'work'});
        final ref = firestore
            .collection('users')
            .doc((firebaseAuth.currentUser?.uid))
            .collection('categories');
        var querySnap = await ref.where('name', isEqualTo: 'work').get();
        var queryDocSnap = querySnap.docs.first;
        var data = queryDocSnap.data();
        expect(data['name'], 'work');
        final updatedModel = CategoryModel.fromMap(data).copyWith(name: 'travel');
        await categoryRepository.updateCategory(updatedModel);
        var docSnap = await ref.doc(data['id']).get();
        data = docSnap.data()!;
        expect(data['name'], 'travel');
        await clearFirebase();
      });

      test('should throw UserNotLoggedInException', () {
        expect(
          () async =>
              await categoryRepository.updateCategory(CategoryModel(id: 'xxx', name: 'work')),
          throwsA(isA<UserNotLoggedInException>()),
        );
      });
    });

    group('test delete category', () {
      test('should throw UserNotLoggedInException', () {
        expect(
          () async => await categoryRepository.deleteCategory('xxx'),
          throwsA(isA<UserNotLoggedInException>()),
        );
      });

      test('should delete category', () async {
        await authRepository.register(
          {'name': 'tony', 'email': 'tony@email.com'},
          'test123',
          'test123',
        );
        await categoryRepository.addCategory({'name': 'work'});
        final ref = firestore
            .collection('users')
            .doc((firebaseAuth.currentUser?.uid))
            .collection('categories');
        var querySnap = await ref.where('name', isEqualTo: 'work').get();
        var queryDocSnap = querySnap.docs.first;
        var data = queryDocSnap.data();
        expect(data['name'], 'work');
        await categoryRepository.deleteCategory(data['id']);
        querySnap = await ref.where('name', isEqualTo: 'work').get();
        expect(querySnap.docs.length, 0);
        await clearFirebase();
      });
    });

    group('test add category', () {
      test('should throw UserNotLoggedInException', () {
        expect(
          () async => await categoryRepository.addCategory({'name': 'work'}),
          throwsA(isA<UserNotLoggedInException>()),
        );
      });

      test('should add collection', () async {
        await authRepository.register(
          {'name': 'tony', 'email': 'tony@email.com'},
          'test123',
          'test123',
        );
        await categoryRepository.addCategory({'name': 'work'});
        final querySnap =
            await firestore
                .collection('users')
                .doc((firebaseAuth.currentUser?.uid))
                .collection('categories')
                .where('name', isEqualTo: 'work')
                .get();
        final queryDocSnap = querySnap.docs.first;
        final data = queryDocSnap.data();
        expect(data['name'], 'work');
        await clearFirebase();
      });
    });
  });
}
