import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/view/register/util/register_form_data.dart';

class RegisterFirstnameField extends StatelessWidget {
  const RegisterFirstnameField({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_firstnameFieldTitle(), _firstnameField(context)],
      ),
    );
  }

  Widget _firstnameFieldTitle() {
    return Text('First name', style: GoogleFonts.merriweather(fontSize: 20));
  }

  Widget _firstnameField(BuildContext context) {
    return SizedBox(
      height: 30,
      child: TextFormField(
        controller: RegisterFormData.of(context)!.nameController,
        decoration: InputDecoration(hintText: 'Enter your first name'),
      ),
    );
  }
}
