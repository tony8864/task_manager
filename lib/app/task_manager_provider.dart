import 'package:flutter/widgets.dart';
import 'package:task_manager/app/task_manager.dart';
import 'package:task_manager/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/data/repository/auth_repository/auth_repository.dart';

class TaskManagerProvider extends StatelessWidget {
  final AuthRepository authRepository;

  const TaskManagerProvider({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create:
              (context) => AuthBloc(authRepository: authRepository)..add(AuthSubscriptionEvent()),
        ),
      ],
      child: TaskManager(authRepository: authRepository),
    );
  }
}
