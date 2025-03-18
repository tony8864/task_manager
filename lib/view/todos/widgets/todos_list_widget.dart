import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/model/category_model.dart';
import 'package:task_manager/data/model/todo_model.dart';
import 'package:task_manager/view/todos/widgets/todo_item.dart';

class TodosListWidget extends StatelessWidget {
  final CategoryModel categoryModel;

  const TodosListWidget({super.key, required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final stream =
        FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('categories')
            .doc(categoryModel.id)
            .collection('todos')
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
            child: _todosList(snapshot, context),
          );
        },
      ),
    );
  }

  Widget _todosList(
    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
    BuildContext context,
  ) {
    if (snapshot.data!.docs.isEmpty) {
      return _emptyTodoMessage(context);
    }

    return _buildTodoList(snapshot, context);
  }

  Widget _emptyTodoMessage(BuildContext context) {
    return Center(
      child: Text(
        'No todos available.',
        style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }

  Widget _buildTodoList(
    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
    BuildContext context,
  ) {
    return ListView.builder(
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) {
        DocumentSnapshot document = snapshot.data!.docs[index];
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        final todoModel = TodoModel.fromMap(data);
        return TodoItem(todoModel: todoModel, categoryModel: categoryModel);
      },
    );
  }
}
