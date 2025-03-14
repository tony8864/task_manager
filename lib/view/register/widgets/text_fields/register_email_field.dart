import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/view/register/util/register_form_data.dart';

class RegisterEmailField extends StatelessWidget {
  const RegisterEmailField({super.key});


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_emailFieldTitle(), _emailField(context)],
      ),
    );
  }

  Widget _emailFieldTitle() {
    return Text('Email', style: GoogleFonts.merriweather(fontSize: 20));
  }

  Widget _emailField(BuildContext context) {
    return SizedBox(
      height: 30,
      child: TextFormField(
        controller: RegisterFormData.of(context)!.emailController,
        decoration: InputDecoration(hintText: 'Enter your email'),
      ),
    );
  }
}
