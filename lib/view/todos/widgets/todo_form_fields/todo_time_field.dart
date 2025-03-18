import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/view/todos/util/todo_form_data.dart';

class TodoTimeField extends StatelessWidget {
  const TodoTimeField({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_timeLabel(), const SizedBox(height: 4), _timeField(context)],
      ),
    );
  }

  Widget _timeLabel() {
    return Text('Time', style: GoogleFonts.merriweather(fontSize: 20));
  }

  Widget _timeField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.datetime,
      controller: TodoFormData.of(context)!.timeController,
      maxLength: 5,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      counterText: '',
      hintText: 'HH:MM',
      hintStyle: const TextStyle(color: Colors.white70),
      border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      filled: true,
      fillColor: Colors.black,
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    );
  }
}
