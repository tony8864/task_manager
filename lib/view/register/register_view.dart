// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/view/register/widgets/register_form_widget.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_titleContainer(context), _formContainer()],
      ),
    );
  }

  Widget _titleContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 100),
      child: Text(
        'Create Account!',
        style: GoogleFonts.merriweather(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 40,
        ),
      ),
    );
  }

  Widget _formContainer() {
    return Flexible(child: SingleChildScrollView(child: RegisterFormWidget()));
  }
}
