import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/category_bloc/category_bloc.dart';
import 'package:task_manager/bloc/login_form_bloc/login_form_bloc.dart';
import 'package:task_manager/bloc/register_form_bloc/register_form_bloc.dart';
import 'package:task_manager/bloc/todo_bloc/todo_bloc.dart';
import 'package:task_manager/bloc/user_bloc/user_bloc.dart';
import 'package:task_manager/core/service_locator.dart';
import 'package:task_manager/data/model/category_model.dart';
import 'package:task_manager/data/model/todo_model.dart';
import 'package:task_manager/data/repository/category_repository.dart/firebase_category_repository.dart';
import 'package:task_manager/data/repository/todo_repository/firebase_todo_repository.dart';
import 'package:task_manager/data/repository/user_repository/firebase_user_repository.dart';
import 'package:task_manager/view/categories/categories_view.dart';
import 'package:task_manager/view/login/login_view.dart';
import 'package:task_manager/view/onboarding/onboarding_view.dart';
import 'package:task_manager/view/register/register_view.dart';
import 'package:task_manager/view/settings/settings_view.dart';
import 'package:task_manager/view/todos/todo_view.dart';
import 'package:task_manager/view/todos/todos_view.dart';

class AppRouter {
  static GoRouter getRouter(bool isAuthenticated) {
    return GoRouter(
      initialLocation: !isAuthenticated ? '/' : '/categories',
      routes: [_onBoardingRoute(), _categoriesRoute(), _todoRoute()],
    );
  }

  static GoRoute _onBoardingRoute() {
    return GoRoute(
      path: '/',
      builder: (context, state) => const OnboardingView(),
      routes: [_registerRoute(), _loginRoute()],
    );
  }

  static GoRoute _registerRoute() {
    return GoRoute(
      path: 'register',
      builder:
          (context, state) =>
              BlocProvider(create: (_) => RegisterFormBloc(), child: const RegisterView()),
    );
  }

  static GoRoute _loginRoute() {
    return GoRoute(
      path: 'login',
      builder:
          (context, state) =>
              BlocProvider(create: (_) => LoginFormBloc(), child: const LoginView()),
    );
  }

  static GoRoute _categoriesRoute() {
    return GoRoute(
      path: '/categories',
      builder: _categoriesRouteBuilder,
      routes: [_categoryTodosRoute(), _settingsRoute()],
    );
  }

  static Widget _categoriesRouteBuilder(BuildContext context, GoRouterState state) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (_) => UserBloc(userRepository: getIt<FirebaseUserRepository>()),
        ),
        BlocProvider<CategoryBloc>(create: (_) => CategoryBloc()),
      ],
      child: const CategoriesView(),
    );
  }

  static GoRoute _settingsRoute() {
    return GoRoute(path: 'settings', builder: (context, state) => const SettingsView());
  }

  static GoRoute _categoryTodosRoute() {
    return GoRoute(
      path: ':categoryId/todos',
      builder: (context, state) {
        final cid = state.pathParameters['categoryId']!;
        return _categoryTodosRouteBuilder(cid);
      },
    );
  }

  static GoRoute _todoRoute() {
    return GoRoute(
      path: '/categories/:categoryId/todos/:todoId',
      builder: (context, state) {
        final cid = state.pathParameters['categoryId']!;
        final tid = state.pathParameters['todoId']!;
        return _todoRouteBuilder(cid, tid);
      },
    );
  }

  static FutureBuilder _categoryTodosRouteBuilder(String cid) {
    return FutureBuilder(
      future: GetIt.instance.get<FirebaseCategoryRepository>().findById(cid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Theme.of(context).colorScheme.primary,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                strokeWidth: 1,
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.hasData) {
          final categoryMap = snapshot.data!;
          final categoryModel = CategoryModel.fromMap(categoryMap);

          return BlocProvider(
            create: (context) => TodoBloc(),
            child: TodosView(categoryModel: categoryModel),
          );
        }

        return Center(child: Text('No data available'));
      },
    );
  }

  static FutureBuilder _todoRouteBuilder(String cid, String tid) {
    return FutureBuilder(
      future: GetIt.instance.get<FirebaseTodoRepository>().findById(cid, tid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Theme.of(context).colorScheme.primary,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                strokeWidth: 1,
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.hasData) {
          final categoryMap = snapshot.data!;
          final todoModel = TodoModel.fromMap(categoryMap);

          return BlocProvider(
            create: (context) => TodoBloc(),
            child: TodoView(categoryId: cid, todoModel: todoModel),
          );
        }

        return Center(child: Text('No data available'));
      },
    );
  }
}
