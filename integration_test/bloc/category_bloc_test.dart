import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/bloc/category_bloc/category_bloc.dart';
import 'package:task_manager/data/model/category_model.dart';
import 'package:task_manager/data/repository/auth_repository/firebase_auth_repository.dart';
import 'package:task_manager/data/repository/category_repository.dart/category_repository.dart';
import 'package:task_manager/data/repository/category_repository.dart/firebase_category_repository.dart';
import 'package:task_manager/data/repository/user_repository/firebase_user_repository.dart';
import 'package:task_manager/firebase_options.dart';

void main() {
  //Bloc.observer = MyBlocObserver();
  group('test category bloc', () {
    late FirebaseFirestore firestore;
    late FirebaseAuth firebaseAuth;
    late FirebaseUserRepository userRepository;
    late FirebaseAuthRepository authRepository;
    late CategoryRepository categoryRepository;
    late CategoryBloc categoryBloc;
    late Map<String, dynamic> userModelMap;
    late Map<String, dynamic> categoryModelMap;

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
      userRepository = FirebaseUserRepository();
      authRepository = FirebaseAuthRepository(userRepository: userRepository);
      categoryRepository = FirebaseCategoryRepository();
      categoryBloc = CategoryBloc(categoryRepository: categoryRepository);
      userModelMap = {'name': 'tony', 'email': 'tony@email.com'};
      categoryModelMap = {'name': 'work'};
    });

    group('test category subscription', () {
      blocTest(
        'should emit CategoriesFetched',
        build: () => categoryBloc,
        setUp: () async => await authRepository.register(userModelMap, 'test123', 'test123'),
        act: (bloc) async {
          bloc.add(CategorySubscriptionEvent());
          await categoryRepository.addCategory(categoryModelMap);
          await categoryRepository.addCategory(categoryModelMap);
          await categoryRepository.addCategory(categoryModelMap);
          await categoryRepository.addCategory(categoryModelMap);
        },
        wait: const Duration(milliseconds: 2000),
        expect:
            () => [
              isA<CategoriesFetched>(),
              isA<CategoriesFetched>(),
              isA<CategoriesFetched>(),
              isA<CategoriesFetched>(),
            ],
        tearDown: () async => await clearFirebase(),
      );
    });

    group('test update category', () {
      blocTest(
        'should emit CategorySuccess when updating category',
        build: () => categoryBloc,
        setUp: () async => await authRepository.register(userModelMap, 'test123', 'test123'),
        act: (bloc) async {
          final cid = await categoryRepository.addCategory(categoryModelMap);
          final updatedModel = CategoryModel.fromMap(categoryModelMap..addAll({'id': cid}));
          bloc.add(UpdateCategoryEvent(categoryModel: updatedModel));
        },
        wait: const Duration(milliseconds: 2000),
        expect: () => [isA<CategoryLoading>(), isA<CategorySuccess>()],
        tearDown: () async => await clearFirebase(),
      );

      blocTest(
        'should emit CategoryFailure when updating category',
        build: () => categoryBloc,
        act: (bloc) {
          final updatedModel = CategoryModel.fromMap(categoryModelMap..addAll({'id': 'xxx'}));
          bloc.add(UpdateCategoryEvent(categoryModel: updatedModel));
        },
        wait: const Duration(milliseconds: 2000),
        expect: () => [isA<CategoryLoading>(), isA<CategoryFailure>()],
      );
    });

    group('test delete category', () {
      blocTest(
        'should emit CategorySuccess when deleting category',
        build: () => categoryBloc,
        setUp: () async => await authRepository.register(userModelMap, 'test123', 'test123'),
        act: (bloc) async {
          final cid = await categoryRepository.addCategory(categoryModelMap);
          bloc.add(DeleteCategoryEvent(cid: cid));
        },
        wait: const Duration(milliseconds: 2000),
        expect: () => [isA<CategoryLoading>(), isA<CategorySuccess>()],
        tearDown: () async => await clearFirebase(),
      );

      blocTest(
        'should emit CategoryFailure when deleting category',
        build: () => categoryBloc,
        act: (bloc) => bloc.add(DeleteCategoryEvent(cid: '1')),
        wait: const Duration(milliseconds: 2000),
        expect: () => [isA<CategoryLoading>(), isA<CategoryFailure>()],
      );
    });

    group('test add category', () {
      blocTest(
        'should emit CategorySuccess when adding category',
        build: () => categoryBloc,
        setUp: () async => await authRepository.register(userModelMap, 'test123', 'test123'),
        act: (bloc) async {
          bloc.add(AddCategoryEvent(categoryMap: categoryModelMap));
          await Future.delayed(const Duration(milliseconds: 2000));
          bloc.add(AddCategoryEvent(categoryMap: categoryModelMap));
          await Future.delayed(const Duration(milliseconds: 2000));
          bloc.add(AddCategoryEvent(categoryMap: categoryModelMap));
          await Future.delayed(const Duration(milliseconds: 2000));
          bloc.add(AddCategoryEvent(categoryMap: categoryModelMap));
        },
        wait: const Duration(milliseconds: 2000),
        expect:
            () => [
              isA<CategoryLoading>(),
              isA<CategorySuccess>(),
              isA<CategoryLoading>(),
              isA<CategorySuccess>(),
              isA<CategoryLoading>(),
              isA<CategorySuccess>(),
              isA<CategoryLoading>(),
              isA<CategorySuccess>(),
            ],
        tearDown: () async => await clearFirebase(),
      );

      blocTest(
        'should emit CategoryFailure when adding category',
        build: () => categoryBloc,
        act: (bloc) => bloc.add(AddCategoryEvent(categoryMap: categoryModelMap)),
        wait: const Duration(milliseconds: 2000),
        expect: () => [isA<CategoryLoading>(), isA<CategoryFailure>()],
      );
    });
  });
}
