import 'package:flutter/material.dart';

class CategoryFormData extends InheritedWidget {
  final TextEditingController nameController;

  const CategoryFormData({super.key, required super.child, required this.nameController});

  String get name => nameController.text.trim();


  static CategoryFormData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CategoryFormData>();
  }

  @override
  bool updateShouldNotify(CategoryFormData oldWidget) {
    return false;
  }
}
