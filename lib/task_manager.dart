import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/auth_bloc/auth_bloc.dart';
import 'package:task_manager/core/app_router.dart';

class TaskManager extends StatelessWidget {
  final ThemeData theme = ThemeData();

  TaskManager({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: _streamBuilder(),
    );
  }

  Widget _streamBuilder() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final bool isAuthenticated = snapshot.hasData;
        return _materiAppRoute(isAuthenticated);
      },
    );
  }

  Widget _materiAppRoute(bool isAuthenticated) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: _themeData(),
      routerConfig: AppRouter.getRouter(isAuthenticated),
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
