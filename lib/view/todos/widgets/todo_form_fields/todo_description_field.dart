import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/view/todos/util/todo_form_data.dart';

class TodoDescriptionField extends StatelessWidget {
  const TodoDescriptionField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_descriptionTitle(), const SizedBox(height: 4), _descriptionField(context)],
    );
  }

  Widget _descriptionTitle() {
    return Text('Description', style: GoogleFonts.merriweather(fontSize: 20));
  }

  Widget _descriptionField(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return SizedBox(
      width: MediaQuery.of(context).size.width - 100,
      height: 150,
      child: Scrollbar(
        controller: scrollController,
        thumbVisibility: true,
        child: TextFormField(
          controller: TodoFormData.of(context)!.descriptionController,
          scrollController: scrollController,
          style: const TextStyle(color: Colors.white),
          maxLines: null,
          minLines: 5,
          keyboardType: TextInputType.multiline,
          textAlignVertical: TextAlignVertical.top,
          decoration: _inputDecoration(context),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context) {
    return InputDecoration(
      hintText: 'Enter task details...',
      hintStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.black,
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      floatingLabelBehavior: FloatingLabelBehavior.always,
    );
  }
}
