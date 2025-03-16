// import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/bloc/user_bloc/user_bloc.dart';

class CategoriesTitleWidget extends StatelessWidget {
  const CategoriesTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<UserBloc>().add(FetchUsernameEvent());

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return Text(
            'Hi, ${state.username}',
            style: GoogleFonts.merriweather(
              fontSize: 40,
              color: Theme.of(context).colorScheme.secondary,
            ),
          );
        } else {
          return Text('');
        }
      },
    );
  }
}
