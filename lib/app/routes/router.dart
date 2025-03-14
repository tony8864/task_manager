import 'package:go_router/go_router.dart';
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
        GoRoute(path: 'register', builder: (context, state) => RegisterView()),
        GoRoute(path: 'login', builder: (context, state) => LoginView()),
      ],
    ),
  ],
);
