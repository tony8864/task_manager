//import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/category_bloc/category_bloc.dart';
import 'package:task_manager/data/model/category_model.dart';
import 'package:task_manager/view/categories/widgets/category_item.dart';

class CategoriesListWidget extends StatelessWidget {
  const CategoriesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final stream =
        FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('categories')
            .snapshots();
    return Expanded(
      child: StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          return Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: _categoryList(snapshot, context),
          );
        },
      ),
    );
  }

  Widget _categoryList(
    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
    BuildContext context,
  ) {
    return ListView.builder(
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) {
        DocumentSnapshot document = snapshot.data!.docs[index];
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        final categoryModel = CategoryModel.fromMap(data);
        return CategoryItem(
          categoryModel: categoryModel,
          onDelete: (String cid) {
            context.read<CategoryBloc>().add(DeleteCategoryEvent(cid: cid));
          },
        );
      },
    );
  }
}
