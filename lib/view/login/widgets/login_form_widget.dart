import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/bloc/auth_bloc/auth_bloc.dart';
import 'package:task_manager/bloc/login_form_bloc/login_form_bloc.dart';
import 'package:task_manager/shared/widgets/abstract_email_field.dart';
import 'package:task_manager/shared/widgets/abstract_password_field.dart';
import 'package:task_manager/shared/widgets/primary_button.dart';
import 'package:task_manager/view/login/util/login_form_data.dart';

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
      child: Form(key: _formKey, child: _FormContent()),
    );
  }
}

class _FormContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 2),
        _emailField(LoginFormData.of(context)!.emailController),
        const Spacer(flex: 1),
        _passwordField(LoginFormData.of(context)!.passwordController),
        const Spacer(flex: 2),
        _submitButton(context),
        const Spacer(flex: 1),
        _signUpRedirect(context),
        const Spacer(flex: 3),
      ],
    );
  }

  Widget _emailField(TextEditingController controller) {
    return AbstractEmailField(controller: controller, isRegister: false);
  }

  Widget _passwordField(TextEditingController controller) {
    return BlocBuilder<LoginFormBloc, LoginFormState>(
      builder: (context, state) {
        return AbstractPasswordField(
          fieldTitle: 'Password',
          controller: controller,
          unauthenticatedStatus: UnauthenticatedStatus.invalidCredentials,
          errorText: 'Invalid credentials',
          hintText: 'Enter a strong password',
          isVisible: state.isPasswordVisible,
          onVisibilityToggle: () {
            context.read<LoginFormBloc>().add(ToggleLoginPasswordVisibilityEvent());
          },
        );
      },
    );
  }

  Widget _submitButton(BuildContext context) {
    return PrimaryButton(
      text: 'Log in',
      textColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.primary,
      onPressed:
          () =>
              _areTextFieldsEmpty(context) ? _showErrorSnackbar(context) : _fireLoginEvent(context),
    );
  }

  bool _areTextFieldsEmpty(BuildContext context) {
    final formData = LoginFormData.of(context)!;
    return formData.email.isEmpty || formData.password.isEmpty;
  }

  void _showErrorSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You cannot leave any field empty'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _fireLoginEvent(BuildContext context) {
    final formData = LoginFormData.of(context)!;
    context.read<AuthBloc>().add(LoginEvent(email: formData.email, password: formData.password));
  }

  Widget _signUpRedirect(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Don\'t have an account?', style: GoogleFonts.merriweather(fontSize: 20)),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(ResetAuthStateEvent());
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
