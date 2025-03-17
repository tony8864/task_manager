import 'package:get_it/get_it.dart';
import 'package:task_manager/data/repository/auth_repository/firebase_auth_repository.dart';
import 'package:task_manager/data/repository/category_repository.dart/firebase_category_repository.dart';
import 'package:task_manager/data/repository/todo_repository/firebase_todo_repository.dart';
import 'package:task_manager/data/repository/user_repository/firebase_user_repository.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Register repositories
  getIt.registerLazySingleton<FirebaseUserRepository>(() => FirebaseUserRepository());
  getIt.registerLazySingleton<FirebaseAuthRepository>(() => FirebaseAuthRepository());
  getIt.registerLazySingleton<FirebaseCategoryRepository>(() => FirebaseCategoryRepository());
  getIt.registerLazySingleton<FirebaseTodoRepository>(() => FirebaseTodoRepository());
}
