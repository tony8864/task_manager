import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/bloc/todo_bloc/todo_bloc.dart';
import 'package:task_manager/data/model/category_model.dart';
import 'package:task_manager/shared/widgets/nav_widget.dart';
import 'package:task_manager/view/todos/widgets/todo_form_widget.dart';
import 'package:task_manager/view/todos/widgets/todos_list_widget.dart';

class TodosView extends StatelessWidget {
  final CategoryModel categoryModel;

  const TodosView({super.key, required this.categoryModel});

  void _onCreateTodo(BuildContext context) async {
    final todoMap = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return TodoFormWidget();
      },
    );

    if (!context.mounted) {
      return;
    }

    context.read<TodoBloc>().add(
      AddTodoEvent(categoryModel.id, {...todoMap, 'isCompleted': false}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _categoryName(context), centerTitle: true, leading: _leading(context)),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        padding: EdgeInsets.only(top: 20),
        width: double.infinity,
        child: Column(
          children: [
            _horizontalLine(Theme.of(context).colorScheme.secondary),
            const SizedBox(height: 40),
            TodosListWidget(categoryModel: categoryModel),
            _navbar(context),
          ],
        ),
      ),
    );
  }

  Widget _categoryName(BuildContext context) {
    return Text(
      '${categoryModel.name[0].toUpperCase()}${categoryModel.name.substring(1)}',
      style: GoogleFonts.merriweather(fontSize: 40, color: Theme.of(context).colorScheme.secondary),
    );
  }

  Widget _leading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0),
      child: IconButton(
        icon: Icon(Icons.arrow_back_ios, size: 30, color: Theme.of(context).colorScheme.secondary),
        onPressed: () {
          context.go('/categories');
        },
      ),
    );
  }

  Widget _horizontalLine(Color color) {
    return Divider(color: color, thickness: 1, indent: 20, endIndent: 20);
  }

  Widget _navbar(BuildContext context) {
    return NavWidget(
      isHomeActive: true,
      isFloatingButtonActive: true,
      onPressed: () {
        _onCreateTodo(context);
      },
    );
  }
}
