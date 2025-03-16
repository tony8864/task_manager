import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/bloc/auth_bloc/auth_bloc.dart';

class AbstractEmailField extends StatelessWidget {
  final TextEditingController controller;
  final bool isRegister;

  const AbstractEmailField({super.key, required this.controller, required this.isRegister});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_emailFieldTitle(), _emailAreaBuilder()],
      ),
    );
  }

  Widget _emailFieldTitle() {
    return Text('Email', style: GoogleFonts.merriweather(fontSize: 20));
  }

  Widget _emailAreaBuilder() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return _emailArea(context, state);
      },
    );
  }

  Widget _emailArea(BuildContext context, AuthState state) {
    return Column(children: [_emailField(context), const SizedBox(height: 4), _emailError(state)]);
  }

  Widget _emailField(BuildContext context) {
    return SizedBox(
      height: 30,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(hintText: 'Enter your email'),
      ),
    );
  }

  Widget _emailError(AuthState authState) {
    String? errorMessage;

    if (authState is Unauthenticated) {
      if (authState.status == UnauthenticatedStatus.badEmailFormat) {
        errorMessage = 'Bad email format';
      } else if (authState.status == UnauthenticatedStatus.duplicateEmail && isRegister) {
        errorMessage = 'Email already in use';
      }
    }

    return Container(
      height: errorMessage != null ? 16 : 0,
      alignment: Alignment.centerLeft,
      child:
          errorMessage != null
              ? Text(errorMessage, style: GoogleFonts.merriweather(fontSize: 13, color: Colors.red))
              : null,
    );
  }
}
