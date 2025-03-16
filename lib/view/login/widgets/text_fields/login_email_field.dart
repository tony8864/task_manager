import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/bloc/auth_bloc/auth_bloc.dart';
import 'package:task_manager/view/login/util/login_form_data.dart';

class LoginEmailField extends StatelessWidget {
  const LoginEmailField({super.key});

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
        controller: LoginFormData.of(context)!.emailController,
        decoration: InputDecoration(hintText: 'Enter your email'),
      ),
    );
  }

  Widget _emailError(AuthState authState) {
    String? errorMessage;

    if (authState is Unauthenticated) {
      if (authState.status == UnauthenticatedStatus.badEmailFormat) {
        errorMessage = 'Bad email format';
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
