import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/bloc/auth_bloc/auth_bloc.dart';
import 'package:task_manager/bloc/login_form_bloc/login_form_bloc.dart';
import 'package:task_manager/view/login/util/login_form_data.dart';

class LoginPasswordField extends StatelessWidget {
  const LoginPasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_passwordFieldTitle(), _passwordAreaBuilder()],
      ),
    );
  }

  Widget _passwordFieldTitle() {
    return Text('Password', style: GoogleFonts.merriweather(fontSize: 20));
  }

  Widget _passwordAreaBuilder() {
    return Builder(
      builder: (context) {
        final authState = context.watch<AuthBloc>().state;
        final loginFormState = context.watch<LoginFormBloc>().state;
        return _passwordArea(context, authState, loginFormState);
      },
    );
  }

  Widget _passwordArea(
    BuildContext context,
    AuthState authState,
    LoginFormState loginFormState,
  ) {
    return Column(
      children: [
        _passwordField(context, loginFormState),
        const SizedBox(height: 4),
        _passwordError(authState),
      ],
    );
  }

  Widget _passwordField(BuildContext context, LoginFormState loginFormState) {
    return SizedBox(
      height: 30,
      child: TextFormField(
        obscureText: !loginFormState.isPasswordVisible,
        controller: LoginFormData.of(context)!.passwordController,
        decoration: InputDecoration(
          hintText: 'Enter your password',
          suffixIcon: _visibilityIconButton(context, loginFormState),
        ),
      ),
    );
  }

  Widget _passwordError(AuthState authState) {
    bool showError =
        authState is Unauthenticated &&
        authState.status == UnauthenticatedStatus.invalidCredentials;

    return Container(
      height: showError ? 16 : 0,
      alignment: Alignment.centerLeft,
      child:
          showError
              ? Text(
                'Invalid credentials',
                style: GoogleFonts.merriweather(fontSize: 13, color: Colors.red),
              )
              : null,
    );
  }

  Widget _visibilityIconButton(BuildContext context, LoginFormState loginFormState) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          context.read<LoginFormBloc>().add(ToggleLoginPasswordVisibilityEvent());
        },
        icon: loginFormState.isPasswordVisible ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
      ),
    );
  }
}
