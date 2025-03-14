import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/view/register/util/register_form_data.dart';

class RegisterConfirmPasswordField extends StatelessWidget {
  const RegisterConfirmPasswordField({super.key});

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
    return Text('Confirm Password', style: GoogleFonts.merriweather(fontSize: 20));
  }

  Widget _passwordField(BuildContext context) {
    return SizedBox(
      height: 30,
      child: TextFormField(
        controller: RegisterFormData.of(context)!.confirmPasswordController,
        decoration: InputDecoration(
          hintText: 'Retype your password',
          suffixIcon: Icon(Icons.visibility),
        ),
      ),
    );
  }
}
