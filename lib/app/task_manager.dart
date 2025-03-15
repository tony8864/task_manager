import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:task_manager/app/routes/router.dart';
import 'package:task_manager/data/repository/auth_repository/auth_repository.dart';

class TaskManager extends StatelessWidget {
  final ThemeData theme = ThemeData();
  final AuthRepository authRepository;

  TaskManager({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: _themeData(),   
      routerConfig: onboardingRouter,
    );
  }

  ThemeData _themeData() {
    return theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(
        primary: const Color.fromARGB(255, 16, 24, 32),
        secondary: const Color.fromARGB(255, 254, 231, 21),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 16, 24, 32),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 254, 231, 21)),
      ),
    );
  }
}
