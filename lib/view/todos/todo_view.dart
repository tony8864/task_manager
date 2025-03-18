import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/data/model/todo_model.dart';
import 'package:task_manager/shared/widgets/nav_widget.dart';

class TodoView extends StatelessWidget {
  final String categoryId;
  final TodoModel todoModel;

  const TodoView({super.key, required this.categoryId, required this.todoModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _todoTitle(context), centerTitle: true, leading: _leading(context)),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        padding: EdgeInsets.only(top: 20),
        width: double.infinity,
        child: Column(
          children: [
            _horizontalLine(Theme.of(context).colorScheme.secondary),
            const Spacer(),
            _description(context, Theme.of(context).colorScheme.secondary),
            const SizedBox(height: 20),
            _displayDateTime(Theme.of(context).colorScheme.secondary),
            const Spacer(),
            _navWidget(),
          ],
        ),
      ),
    );
  }

  Widget _todoTitle(BuildContext context) {
    return Text(
      '${todoModel.title[0].toUpperCase()}${todoModel.title.substring(1)}',
      style: GoogleFonts.merriweather(fontSize: 40, color: Theme.of(context).colorScheme.secondary),
    );
  }

  Widget _leading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0),
      child: IconButton(
        icon: Icon(Icons.arrow_back_ios, size: 30, color: Theme.of(context).colorScheme.secondary),
        onPressed: () {
          context.go('/categories/$categoryId/todos');
        },
      ),
    );
  }

  Widget _horizontalLine(Color color) {
    return Divider(color: color, thickness: 1, indent: 20, endIndent: 20);
  }

  Widget _description(BuildContext context, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 400,
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Text(
          todoModel.description,
          style: GoogleFonts.merriweather(
            fontSize: 20,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _displayDateTime(Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            todoModel.dueDate,
            style: TextStyle(fontSize: 16, color: color),
          ),
          SizedBox(width: 10),
          Text(
            todoModel.time,
            style: TextStyle(fontSize: 16, color: color),
          ),
        ],
      ),
    );
  }

  Widget _navWidget() {
    return NavWidget(isHomeActive: true, isFloatingButtonActive: false, onPressed: null);
  }
}
