import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/shared/widgets/primary_button.dart';
import 'package:task_manager/view/login/util/login_form_data.dart';
import 'package:task_manager/view/login/widgets/text_fields/login_email_field.dart';
import 'package:task_manager/view/login/widgets/text_fields/login_password_field.dart';

class LoginFormWidget extends StatelessWidget {
  const LoginFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: _LoginForm(),
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoginFormData(
      emailController: _emailController,
      passwordController: _passwordController,
      child: Form(key: _formKey, child: _formContent()),
    );
  }

  Widget _formContent() {
    return Column(
      children: [
        const Spacer(flex: 2,),
        LoginEmailField(),
        const Spacer(flex: 1,),
        LoginPasswordField(),
        const Spacer(flex: 2,),
        _submitButton(Theme.of(context).colorScheme.primary),
        const Spacer(flex: 1,),
        _signUpRedirect(),
        const Spacer(flex: 3,),
      ],
    );
  }

  Widget _submitButton(Color backgroundColor) {
    return PrimaryButton(
      text: 'Log in',
      textColor: Colors.white,
      backgroundColor: backgroundColor,
      onPressed: () {},
    );
  }

  Widget _signUpRedirect() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Don\'t have an account?', style: GoogleFonts.merriweather(fontSize: 20)),
          TextButton(
            onPressed: () {
              context.go('/register');
            },
            child: Text(
              'Sign up',
              style: GoogleFonts.merriweather(
                fontSize: 20,
                color: Color.fromARGB(255, 0, 157, 255),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
