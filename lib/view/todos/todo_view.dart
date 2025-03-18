import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/core/colors/app_colors.dart';
import 'package:task_manager/data/model/todo_model.dart';
import 'package:task_manager/shared/widgets/nav_widget.dart';

class TodoView extends StatelessWidget {
  final String categoryId;
  final TodoModel todoModel;

  const TodoView({super.key, required this.categoryId, required this.todoModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _todoTitle(Colors.white),
        centerTitle: true,
        leading: _leading(context),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        padding: EdgeInsets.only(top: 20),
        width: double.infinity,
        child: Column(
          children: [
            _horizontalLine(Colors.white),
            const SizedBox(height: 20),
            _description(MediaQuery.of(context).size.width - 40, Colors.white),
            const SizedBox(height: 20),
            _displayDateTime(MediaQuery.of(context).size.width - 40, Colors.white),
            const Spacer(),
            _navWidget(),
          ],
        ),
      ),
    );
  }

  Widget _todoTitle(Color color) {
    return Text(
      '${todoModel.title[0].toUpperCase()}${todoModel.title.substring(1)}',
      style: GoogleFonts.merriweather(fontSize: 40, color: color),
    );
  }

  Widget _leading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0),
      child: IconButton(
        icon: Icon(Icons.arrow_back_ios, size: 30, color: Colors.white),
        onPressed: () {
          context.go('/categories/$categoryId/todos');
        },
      ),
    );
  }

  Widget _horizontalLine(Color color) {
    return Divider(color: color, thickness: 1, indent: 20, endIndent: 20);
  }

  Widget _description(double width, Color color) {
    return Container(
      width: width,
      height: 400,
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.darkBlueGray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Text(
          todoModel.description,
          style: GoogleFonts.merriweather(fontSize: 20, color: color),
        ),
      ),
    );
  }

  Widget _displayDateTime(double width, Color color) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: AppColors.darkBlueGray,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            todoModel.dueDate,
            style: GoogleFonts.merriweather(
              fontSize: 16,
              color: color,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(width: 10),
          Text(
            todoModel.time,
            style: GoogleFonts.merriweather(
              fontSize: 16,
              color: color,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _navWidget() {
    return NavWidget(isHomeActive: true, isFloatingButtonActive: false, onPressed: null);
  }
}
