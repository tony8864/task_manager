import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/category_bloc/category_bloc.dart';
import 'package:task_manager/bloc/login_form_bloc/login_form_bloc.dart';
import 'package:task_manager/bloc/register_form_bloc/register_form_bloc.dart';
import 'package:task_manager/bloc/todo_bloc/todo_bloc.dart';
import 'package:task_manager/bloc/user_bloc/user_bloc.dart';
import 'package:task_manager/core/service_locator.dart';
import 'package:task_manager/data/model/category_model.dart';
import 'package:task_manager/data/repository/user_repository/firebase_user_repository.dart';
import 'package:task_manager/view/categories/categories_view.dart';
import 'package:task_manager/view/login/login_view.dart';
import 'package:task_manager/view/onboarding/onboarding_view.dart';
import 'package:task_manager/view/register/register_view.dart';
import 'package:task_manager/view/settings/settings_view.dart';
import 'package:task_manager/view/todos/todos_view.dart';

class AppRouter {
  static GoRouter getRouter(bool isAuthenticated) {
    return GoRouter(
      initialLocation: isAuthenticated ? '/categories' : '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const OnboardingView(),
          routes: [
            GoRoute(
              path: 'register',
              builder:
                  (context, state) =>
                      BlocProvider(create: (_) => RegisterFormBloc(), child: const RegisterView()),
            ),
            GoRoute(
              path: 'login',
              builder:
                  (context, state) =>
                      BlocProvider(create: (_) => LoginFormBloc(), child: const LoginView()),
            ),
          ],
        ),
        GoRoute(
          path: '/categories',
          builder:
              (context, state) => MultiBlocProvider(
                providers: [
                  BlocProvider<UserBloc>(
                    create: (_) => UserBloc(userRepository: getIt<FirebaseUserRepository>()),
                  ),
                  BlocProvider<CategoryBloc>(create: (_) => CategoryBloc()),
                ],
                child: const CategoriesView(),
              ),
          routes: [
            GoRoute(path: 'settings', builder: (context, state) => const SettingsView()),
            GoRoute(
              path: 'todo/:category',
              builder: (context, state) {
                final categoryJson = state.pathParameters['category']!;
                final categoryMap = Map<String, dynamic>.from(jsonDecode(categoryJson));
                final categoryModel = CategoryModel.fromMap(categoryMap);
                return BlocProvider(
                  create: (context) => TodoBloc(),
                  child: TodosView(categoryModel: categoryModel),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
