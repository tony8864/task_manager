import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/bloc/auth_bloc/auth_bloc.dart';
import 'package:task_manager/bloc/register_form_bloc/register_form_bloc.dart';
import 'package:task_manager/view/register/util/register_form_data.dart';

class RegisterPasswordField extends StatelessWidget {
  const RegisterPasswordField({super.key});

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
        final registerFormState = context.watch<RegisterFormBloc>().state;
        return _passwordArea(context, authState, registerFormState);
      },
    );
  }

  Widget _passwordArea(
    BuildContext context,
    AuthState authState,
    RegisterFormState registerFormState,
  ) {
    return Column(
      children: [
        _passwordField(context, registerFormState),
        const SizedBox(height: 4),
        _passwordError(authState),
      ],
    );
  }

  Widget _passwordField(BuildContext context, RegisterFormState registerFormState) {
    return SizedBox(
      height: 30,
      child: TextFormField(
        obscureText: !registerFormState.isPasswordVisible,
        controller: RegisterFormData.of(context)!.passwordController,
        decoration: InputDecoration(
          hintText: 'Enter a strong password',
          suffixIcon: _visibilityIconButton(context, registerFormState),
        ),
      ),
    );
  }

  Widget _passwordError(AuthState authState) {
    bool showError =
        authState is Unauthenticated && authState.status == UnauthenticatedStatus.weakPassword;

    return Container(
      height: showError ? 16 : 0,
      alignment: Alignment.centerLeft,
      child:
          showError
              ? Text(
                'Weak password',
                style: GoogleFonts.merriweather(fontSize: 13, color: Colors.red),
              )
              : null,
    );
  }

  Widget _visibilityIconButton(BuildContext context, RegisterFormState state) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          context.read<RegisterFormBloc>().add(ToggleRegisterPasswordVisibilityEvent());
        },
        icon: state.isPasswordVisible ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
      ),
    );
  }
}
