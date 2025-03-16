import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/user_bloc/user_bloc.dart';
import 'package:task_manager/data/repository/user_repository/firebase_user_repository.dart';
import 'package:task_manager/shared/widgets/nav_widget.dart';
import 'package:task_manager/view/categories/widgets/categories_title_widget.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      create: (context) => UserBloc(userRepository: FirebaseUserRepository()),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Container(
          padding: EdgeInsets.only(top: 70),
          width: double.infinity,
          child: Column(
            children: [
              CategoriesTitleWidget(),
              const SizedBox(height: 20),
              _horizontalLine(Theme.of(context).colorScheme.secondary),
              const Spacer(),
              NavWidget(isHomeActive: true,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _horizontalLine(Color color) {
    return Divider(color: color, thickness: 1, indent: 20, endIndent: 20);
  }
}
