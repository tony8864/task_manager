import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/bloc/auth_bloc/auth_bloc.dart';

class AbstractPasswordField extends StatelessWidget {
  final String fieldTitle;
  final TextEditingController controller;
  final UnauthenticatedStatus unauthenticatedStatus;
  final String errorText;
  final String hintText;
  final bool isVisible;
  final void Function()? onVisibilityToggle;

  const AbstractPasswordField({
    super.key,
    required this.fieldTitle,
    required this.controller,
    required this.unauthenticatedStatus,
    required this.errorText,
    required this.hintText,
    required this.isVisible,
    required this.onVisibilityToggle,
  });

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
    return Text(fieldTitle, style: GoogleFonts.merriweather(fontSize: 20));
  }

  Widget _passwordAreaBuilder() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) => _passwordArea(context, state),
    );
  }

  Widget _passwordArea(BuildContext context, AuthState authState) {
    return Column(
      children: [_passwordField(context), const SizedBox(height: 4), _passwordError(authState)],
    );
  }

  Widget _passwordField(BuildContext context) {
    return SizedBox(
      height: 30,
      child: TextFormField(
        obscureText: !isVisible,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: _visibilityIconButton(context),
        ),
      ),
    );
  }

  Widget _passwordError(AuthState authState) {
    bool showError = authState is Unauthenticated && authState.status == unauthenticatedStatus;

    return Container(
      height: showError ? 16 : 0,
      alignment: Alignment.centerLeft,
      child:
          showError
              ? Text(errorText, style: GoogleFonts.merriweather(fontSize: 13, color: Colors.red))
              : null,
    );
  }

  Widget _visibilityIconButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onVisibilityToggle,
        icon: isVisible ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
      ),
    );
  }
}
