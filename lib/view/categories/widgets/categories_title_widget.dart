// import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/bloc/user_bloc/user_bloc.dart';

class CategoriesTitleWidget extends StatefulWidget {
  const CategoriesTitleWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CategoriesTitleWidgetState();
  }
}

class _CategoriesTitleWidgetState extends State<CategoriesTitleWidget> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(FetchUsernameEvent());
  }

  @override
  Widget build(BuildContext context) {
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
