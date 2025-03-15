import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/bloc/auth_bloc/auth_bloc.dart';
import 'package:task_manager/bloc/register_form_bloc/register_form_bloc.dart';
import 'package:task_manager/view/register/util/register_form_data.dart';

class RegisterConfirmPasswordField extends StatelessWidget {
  const RegisterConfirmPasswordField({super.key});

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
    return Text('Confirm Password', style: GoogleFonts.merriweather(fontSize: 20));
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
        obscureText: !registerFormState.isConfirmPasswordVisible,
        controller: RegisterFormData.of(context)!.confirmPasswordController,
        decoration: InputDecoration(
          hintText: 'Retype your password',
          suffixIcon: _visibilityIconButton(context, registerFormState),
        ),
      ),
    );
  }

  Widget _passwordError(AuthState authState) {
    bool showError =
        authState is Unauthenticated && authState.status == UnauthenticatedStatus.passwordMismatch;

    return Container(
      height: showError ? 16 : 0,
      alignment: Alignment.centerLeft,
      child:
          showError
              ? Text(
                'Passwords do no match',
                style: GoogleFonts.merriweather(fontSize: 13, color: Colors.red),
              )
              : null,
    );
  }

  Widget _visibilityIconButton(BuildContext context, RegisterFormState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          context.read<RegisterFormBloc>().add(ToggleRegisterConfirmPasswordVisibilityEvent());
        },
        icon: state.isConfirmPasswordVisible ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
      ),
    );
  }
}
