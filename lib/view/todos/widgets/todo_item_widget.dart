import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/bloc/todo_bloc/todo_bloc.dart';
import 'package:task_manager/data/model/category_model.dart';
import 'package:task_manager/data/model/todo_model.dart';
import 'package:task_manager/view/todos/widgets/todo_pop_menu.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoModel todoModel;
  final CategoryModel categoryModel;

  const TodoItemWidget({super.key, required this.todoModel, required this.categoryModel});

  void _onTodoToggleCompletion(BuildContext context) {
    final isCompleted = todoModel.isCompleted;
    final updatedTodo = todoModel.copyWith(isCompleted: !isCompleted);
    context.read<TodoBloc>().add(UpdateTodoEvent(categoryModel.id, updatedTodo));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 100,
        margin: EdgeInsets.only(bottom: 40),
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
        children: [_todoTitle(), TodoPopMenu(categoryModel: categoryModel, todoModel: todoModel)],
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
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
      child: SizedBox(
        width: 40,
        height: 40,
        child: RawMaterialButton(
          onPressed: () {
            _onTodoToggleCompletion(context);
          },
          fillColor: _isCompleteFillColor(context),
          shape: const CircleBorder(side: BorderSide(color: Colors.white)),
          child: _isCompleteIcon(),
        ),
      ),
    );
  }

  Color? _isCompleteFillColor(BuildContext context) {
    return todoModel.isCompleted
        ? const Color.fromARGB(255, 0, 204, 7)
        : Theme.of(context).colorScheme.primary;
  }

  Widget? _isCompleteIcon() {
    return todoModel.isCompleted ? const Icon(Icons.check, color: Colors.white) : null;
  }
}
