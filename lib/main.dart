import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/repository/auth_repository/auth_repository.dart';
import 'package:task_manager/data/repository/auth_repository/firebase_auth_repository.dart';
import 'package:task_manager/data/repository/user_repository/firebase_user_repository.dart';
import 'package:task_manager/data/repository/user_repository/user_repository.dart';
import 'package:task_manager/firebase_options.dart';
import 'package:task_manager/app/task_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final UserRepository userRepository;
  final AuthRepository authRepository;
  userRepository = FirebaseUserRepository();
  authRepository = FirebaseAuthRepository(userRepository: userRepository);
  runApp(TaskManager(authRepository: authRepository));
}