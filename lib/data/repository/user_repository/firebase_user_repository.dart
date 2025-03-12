// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/core/errors/exceptions.dart';
import 'package:task_manager/data/model/user_model.dart';
import 'package:task_manager/data/repository/user_repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserRepository implements UserRepository {
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
  Future<void> addUser(Map<String, dynamic> userMap) async {
    final userId = _getUserId();
    try {
      await _store.collection('users').doc(userId).set(userMap);
    } catch (e) {
      throw Exception('Failed to add user: $e');
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final userId = _getUserId();
    try {
      await _store.collection('users').doc(userId).update(user.toMap());
    } catch (e) {
      throw Exception('Failed to update user');
    }
  }
}
