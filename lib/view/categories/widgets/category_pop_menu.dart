import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/bloc/category_bloc/category_bloc.dart';
import 'package:task_manager/data/model/category_model.dart';

enum _CategoryMenuAction { delete, edit, view }

class CategoryPopMenu extends StatelessWidget {
  final CategoryModel categoryModel;
  const CategoryPopMenu({super.key, required this.categoryModel});

  void _onMenuItemSelected(BuildContext context, _CategoryMenuAction action) {
    switch (action) {
      case _CategoryMenuAction.delete:
        context.read<CategoryBloc>().add(DeleteCategoryEvent(cid: categoryModel.id));
        break;
      case _CategoryMenuAction.edit:
        break;
      case _CategoryMenuAction.view:
        context.go('/categories/${categoryModel.id}/todos');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_CategoryMenuAction>(
      onSelected: (value) => _onMenuItemSelected(context, value),
      itemBuilder: (context) => [_deleteMenuItem(), _editMenuItem(), _onViewItem()],
      icon: Icon(Icons.dehaze, size: 24, color: Theme.of(context).colorScheme.secondary,),
    );
  }

  PopupMenuEntry<_CategoryMenuAction> _deleteMenuItem() {
    return PopupMenuItem(
      value: _CategoryMenuAction.delete,
      child: Row(
        children: [Icon(Icons.delete, color: Colors.red), SizedBox(width: 8), Text("Delete")],
      ),
    );
  }

  PopupMenuEntry<_CategoryMenuAction> _editMenuItem() {
    return PopupMenuItem<_CategoryMenuAction>(
      value: _CategoryMenuAction.edit,
      child: Row(
        children: [Icon(Icons.edit, color: Colors.blue), SizedBox(width: 8), Text('Edit')],
      ),
    );
  }

  PopupMenuEntry<_CategoryMenuAction> _onViewItem() {
    return PopupMenuItem<_CategoryMenuAction>(
      value: _CategoryMenuAction.view,
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
