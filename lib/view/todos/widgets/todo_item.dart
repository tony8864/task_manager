import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/bloc/todo_bloc/todo_bloc.dart';
import 'package:task_manager/data/model/category_model.dart';
import 'package:task_manager/data/model/todo_model.dart';

class TodoItem extends StatelessWidget {
  final TodoModel todoModel;
  final CategoryModel categoryModel;

  const TodoItem({super.key, required this.todoModel, required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 100,
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_titleContainer(context), _todoStatusWidget(context)],
        ),
      ),
    );
  }

  Widget _titleContainer(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(color: Colors.white, width: 1.0),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_todoTitle(), _popupMenuButton(context)],
      ),
    );
  }

  Widget _todoTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(
        '${todoModel.title[0].toUpperCase()}${todoModel.title.substring(1)}',
        style: GoogleFonts.merriweather(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _popupMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'delete') {
          context.read<TodoBloc>().add(DeleteTodoEvent(categoryModel.id, todoModel.id));
        }
      },
      itemBuilder:
          (context) => [
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text("Delete"),
                ],
              ),
            ),
          ],
      icon: const Icon(Icons.dehaze, size: 24, color: Colors.white),
    );
  }

  Widget _todoStatusWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_dateWidget(), _isCompleteButton(context)],
    );
  }

  Widget _dateWidget() {
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 20),
          const SizedBox(width: 4),
          Text(
            todoModel.dueDate,
            style: GoogleFonts.merriweather(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 20),
          const Icon(Icons.access_time, size: 20),
          const SizedBox(width: 4),
          Text(
            todoModel.time,
            style: GoogleFonts.merriweather(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _isCompleteButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
      child: SizedBox(
        width: 40,
        height: 40,
        child: RawMaterialButton(
          onPressed: () {},
          fillColor: Theme.of(context).colorScheme.primary,
          shape: CircleBorder(side: BorderSide(color: Colors.white)),
        ),
      ),
    );
  }
}
