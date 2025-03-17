import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/view/todos/util/todo_form_data.dart';

class TodoFormTitleField extends StatelessWidget {
  const TodoFormTitleField({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_titleLabel(), _titleTextField(context)],
      ),
    );
  }

  Widget _titleLabel() {
    return Text('Title', style: GoogleFonts.merriweather(fontSize: 20));
  }

  Widget _titleTextField(BuildContext context) {
    return SizedBox(
      height: 30,
      child: TextFormField(
        controller: TodoFormData.of(context)!.titleController,
        decoration: InputDecoration(hintText: 'Enter todo\'s title'),
      ),
    );
  }
}
