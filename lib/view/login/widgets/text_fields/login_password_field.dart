import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/view/login/util/login_form_data.dart';

class LoginPasswordField extends StatelessWidget {
  const LoginPasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_passwordFieldTitle(), _passwordField(context)],
      ),
    );
  }

  Widget _passwordFieldTitle() {
    return Text('Password', style: GoogleFonts.merriweather(fontSize: 20));
  }

  Widget _passwordField(BuildContext context) {
    return SizedBox(
      height: 30,
      child: TextFormField(
        controller: LoginFormData.of(context)!.passwordController,
        decoration: InputDecoration(
          hintText: 'Choose your password',
          suffixIcon: Icon(Icons.visibility),
        ),
      ),
    );
  }
}
