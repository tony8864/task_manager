// ignore_for_file: avoid_print
import 'dart:developer';
import 'package:get_it/get_it.dart';
import 'package:task_manager/core/errors/exceptions.dart';
import 'package:task_manager/data/repository/auth_repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/data/repository/user_repository/firebase_user_repository.dart';
import 'package:task_manager/data/repository/user_repository/user_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserRepository _userRepository = GetIt.instance<FirebaseUserRepository>();

  @override
  User get loggedUser => _firebaseAuth.currentUser!;

  @override
  Future<void> register(
    Map<String, dynamic> userMap,
    String password,
    String confirmPassword,
  ) async {
    if (password != confirmPassword) {
      throw PasswordMismatchException();
    }
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: userMap['email'],
        password: password,
      );

      if (credential.user != null) {
        Map<String, dynamic> userMapWithId = {...userMap, 'id': credential.user?.uid};
        await _userRepository.addUser(userMapWithId);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseException();
      } else if (e.code == 'invalid-email') {
        throw BadEmailFormatException();
      }
    } catch (e) {
      log('Failed to register user with exception: ${e}');
      throw Exception('Failed to register user.');
    }
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw BadEmailFormatException();
      } else if (e.code == 'wrong-password' ||
          e.code == 'user-not-found' ||
          e.code == 'invalid-credential') {
        throw InvalidCredentialsException();
      }
    } catch (e) {
      log('Failed to login user with exception: ${e}');
      throw Exception('Failed to login user: $e');
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  bool isLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }
}
