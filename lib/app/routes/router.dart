import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/bloc/login_form_bloc/login_form_bloc.dart';
import 'package:task_manager/bloc/register_form_bloc/register_form_bloc.dart';
import 'package:task_manager/view/login/login_view.dart';
import 'package:task_manager/view/onboarding/onboarding_view.dart';
import 'package:task_manager/view/register/register_view.dart';

final GoRouter onboardingRouter = GoRouter(
  initialLocation: '/',
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
      ],
    ),
  ],
);
