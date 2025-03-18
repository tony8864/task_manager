//import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/core/errors/exceptions.dart';
import 'package:task_manager/data/model/category_model.dart';
import 'package:task_manager/data/repository/category_repository.dart/category_repository.dart';

class FirebaseCategoryRepository implements CategoryRepository {
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
  Future<String> addCategory(Map<String, dynamic> map) async {
    final userId = _getUserId();
    try {
      final docRef = _store.collection('users').doc(userId).collection('categories').doc();
      await _store
          .collection('users')
          .doc(userId)
          .collection('categories')
          .doc(docRef.id)
          .set({'id': docRef.id}..addAll(map));
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add category.');
    }
  }

  @override
  Future<void> deleteCategory(String cid) async {
    final userId = _getUserId();
    try {
      await _store.collection('users').doc(userId).collection('categories').doc(cid).delete();
    } catch (e) {
      throw Exception('Failed to delete category.');
    }
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    final userId = _getUserId();
    try {
      await _store
          .collection('users')
          .doc(userId)
          .collection('categories')
          .doc(category.id)
          .update(category.toMap());
    } catch (e) {
      throw Exception('Failed to update category.');
    }
  }

  @override
  Future<Map<String, dynamic>> findById(String cid) async {
    final userId = _getUserId();
    try {
      final docSnapshot =
          await _store.collection('users').doc(userId).collection('categories').doc(cid).get();

      if (docSnapshot.exists) {
        return docSnapshot.data()!;
      } else {
        throw Exception('Category not found');
      }
    } catch (e) {
      throw Exception('Failed to find category by id: $e');
    }
  }
}
