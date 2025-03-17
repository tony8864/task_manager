import 'package:flutter/material.dart';

class TodoFormData extends InheritedWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController dueDateController;
  final TextEditingController timeController;

  const TodoFormData({
    super.key,
    required super.child,
    required this.titleController,
    required this.descriptionController,
    required this.dueDateController,
    required this.timeController,
  });

  String get title => titleController.text.trim();
  String get description => descriptionController.text.trim();
  String get dueDate => dueDateController.text.trim();
  String get time => timeController.text.trim();

  static TodoFormData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TodoFormData>();
  }

  @override
  bool updateShouldNotify(TodoFormData oldWidget) {
    return false;
  }
}
