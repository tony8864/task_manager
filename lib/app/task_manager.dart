import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/bloc/login_form_bloc/login_form_bloc.dart';
import 'package:task_manager/bloc/register_form_bloc/register_form_bloc.dart';
import 'package:task_manager/data/repository/auth_repository/auth_repository.dart';
import 'package:task_manager/view/categories/categories_view.dart';
import 'package:task_manager/view/login/login_view.dart';
import 'package:task_manager/view/onboarding/onboarding_view.dart';
import 'package:task_manager/view/register/register_view.dart';
import 'package:task_manager/view/settings/settings_view.dart';

class TaskManager extends StatelessWidget {
  final ThemeData theme = ThemeData();
  final AuthRepository authRepository;

  TaskManager({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
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
      routerConfig: _router(isAuthenticated),
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

  GoRouter _router(bool isAuthenticated) {
    return GoRouter(
      initialLocation: isAuthenticated ? '/home' : '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => OnboardingView(),
          routes: [
            GoRoute(
              path: 'register',
              builder: (context, state) {
                return BlocProvider<RegisterFormBloc>(
                  create: (context) => RegisterFormBloc(),
                  child: RegisterView(),
                );
              },
            ),
            GoRoute(
              path: 'login',
              builder: (context, state) {
                return BlocProvider<LoginFormBloc>(
                  create: (context) => LoginFormBloc(),
                  child: LoginView(),
                );
              },
            ),
            GoRoute(
              path: '/home',
              builder: (context, state) => CategoriesView(),
              routes: [GoRoute(path: 'settings', builder: (context, state) => SettingsView())],
            ),
          ],
        ),
      ],
    );
  }
}
