import 'package:flutter/material.dart';

class LoginFormData extends InheritedWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginFormData({
    super.key,
    required super.child,
    required this.emailController,
    required this.passwordController,
  });

  static LoginFormData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LoginFormData>();
  }

  @override
  bool updateShouldNotify(LoginFormData oldWidget) {
    return false;
  }
}
