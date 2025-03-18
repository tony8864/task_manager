import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/view/todos/util/todo_form_data.dart';

class TodoDueDate extends StatelessWidget {
  final Future<void> Function() onPickDate;

  const TodoDueDate({super.key, required this.onPickDate});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_dueDateTitle(), _dueDateField(context)],
        ),
      ),
    );
  }

  Widget _dueDateTitle() {
    return Text('Due date', style: GoogleFonts.merriweather(fontSize: 20));
  }

  Widget _dueDateField(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextFormField(
        readOnly: true,
        controller: TodoFormData.of(context)!.dueDateController,
        style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.primary),
        decoration: InputDecoration(
          errorText: null,
          hintText: '24 September 2025',
          hintStyle: GoogleFonts.merriweather(
            fontSize: 13,
            color: Theme.of(context).colorScheme.primary,
          ),
          suffix: Transform.translate(
            offset: Offset(0, 8),
            child: IconButton(
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                onPickDate();
              },
              icon: Icon(
                Icons.calendar_month_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}
