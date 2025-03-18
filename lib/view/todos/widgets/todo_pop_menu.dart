import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/bloc/todo_bloc/todo_bloc.dart';
import 'package:task_manager/data/model/category_model.dart';
import 'package:task_manager/data/model/todo_model.dart';

enum _TodoMenuAction { complete, markIncomplete, delete, edit, view }

class TodoPopMenu extends StatelessWidget {
  final CategoryModel categoryModel;
  final TodoModel todoModel;

  const TodoPopMenu({super.key, required this.categoryModel, required this.todoModel});

  void _onMenuItemSelected(BuildContext context, _TodoMenuAction action) {
    switch (action) {
      case _TodoMenuAction.delete:
        context.read<TodoBloc>().add(DeleteTodoEvent(categoryModel.id, todoModel.id));
        break;
      case _TodoMenuAction.complete:
      case _TodoMenuAction.markIncomplete:
        final updatedTodo = todoModel.copyWith(isCompleted: !todoModel.isCompleted);
        context.read<TodoBloc>().add(UpdateTodoEvent(categoryModel.id, updatedTodo));
        break;
      case _TodoMenuAction.edit:
        break;
      case _TodoMenuAction.view:
        GoRouter.of(context).go('/categories/${categoryModel.id}/todos/${todoModel.id}');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_TodoMenuAction>(
      onSelected: (value) => _onMenuItemSelected(context, value),
      itemBuilder:
          (context) => [_deleteMenuItem(), _completeMenuItem(), _editMenuItem(), _onViewItem()],
      icon: const Icon(Icons.dehaze, size: 24, color: Colors.white),
    );
  }

  PopupMenuEntry<_TodoMenuAction> _deleteMenuItem() {
    return PopupMenuItem(
      value: _TodoMenuAction.delete,
      child: Row(
        children: [Icon(Icons.delete, color: Colors.red), SizedBox(width: 8), Text("Delete")],
      ),
    );
  }

  PopupMenuEntry<_TodoMenuAction> _completeMenuItem() {
    return PopupMenuItem(
      value: todoModel.isCompleted ? _TodoMenuAction.markIncomplete : _TodoMenuAction.complete,
      child: Row(
        children: [
          Icon(
            todoModel.isCompleted ? Icons.undo : Icons.check,
            color: todoModel.isCompleted ? Colors.orange : Color.fromARGB(255, 0, 204, 7),
          ),
          SizedBox(width: 8),
          Text(todoModel.isCompleted ? "Mark Incomplete" : "Complete"),
        ],
      ),
    );
  }

  PopupMenuEntry<_TodoMenuAction> _editMenuItem() {
    return PopupMenuItem<_TodoMenuAction>(
      value: _TodoMenuAction.edit,
      child: Row(
        children: [Icon(Icons.edit, color: Colors.blue), SizedBox(width: 8), Text('Edit')],
      ),
    );
  }

  PopupMenuEntry<_TodoMenuAction> _onViewItem() {
    return PopupMenuItem<_TodoMenuAction>(
      value: _TodoMenuAction.view,
      child: Row(
        children: [
          Icon(Icons.visibility, color: const Color.fromARGB(255, 131, 33, 243)),
          SizedBox(width: 8),
          Text('View'),
        ],
      ),
    );
  }
}
