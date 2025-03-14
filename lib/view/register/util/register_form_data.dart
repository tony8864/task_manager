import 'package:flutter/material.dart';

class RegisterFormData extends InheritedWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const RegisterFormData({
    super.key,
    required super.child,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  static RegisterFormData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RegisterFormData>();
  }

  @override
  bool updateShouldNotify(RegisterFormData oldWidget) {
    return false;
  }
}