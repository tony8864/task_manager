import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/bloc/auth_bloc/auth_bloc.dart';
import 'package:task_manager/bloc/register_form_bloc/register_form_bloc.dart';
import 'package:task_manager/shared/widgets/abstract_text_fields/abstract_email_field.dart';
import 'package:task_manager/shared/widgets/abstract_text_fields/abstract_password_field.dart';
import 'package:task_manager/shared/widgets/primary_button.dart';
import 'package:task_manager/view/register/util/register_form_data.dart';

class RegisterFormWidget extends StatelessWidget {
  const RegisterFormWidget({super.key});

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
      child: _RegisterForm(),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<StatefulWidget> createState() {
    return _RegisterFormState();
  }
}

class _RegisterFormState extends State<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RegisterFormData(
      nameController: _nameController,
      emailController: _emailController,
      passwordController: _passwordController,
      confirmPasswordController: _confirmPasswordController,
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
        _nameField(context),
        const Spacer(flex: 1),
        _emailField(RegisterFormData.of(context)!.emailController),
        const Spacer(flex: 1),
        _passwordField(RegisterFormData.of(context)!.passwordController),
        const Spacer(flex: 1),
        _confirmPassword(RegisterFormData.of(context)!.confirmPasswordController),
        const Spacer(flex: 2),
        _submitButton(context),
        const Spacer(flex: 1),
        _signInRedirect(context),
        const Spacer(flex: 3),
      ],
    );
  }

  Widget _nameField(BuildContext context) {
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

  Widget _emailField(TextEditingController controller) {
    return AbstractEmailField(controller: controller, isRegister: true);
  }

  Widget _passwordField(TextEditingController controller) {
    return BlocBuilder<RegisterFormBloc, RegisterFormState>(
      builder: (context, state) {
        return AbstractPasswordField(
          fieldTitle: 'Password',
          controller: controller,
          unauthenticatedStatus: UnauthenticatedStatus.weakPassword,
          errorText: 'Weak password',
          hintText: 'Enter a strong password',
          isVisible: state.isPasswordVisible,
          onVisibilityToggle: () {
            context.read<RegisterFormBloc>().add(ToggleRegisterPasswordVisibilityEvent());
          },
        );
      },
    );
  }

  Widget _confirmPassword(TextEditingController controller) {
    return BlocBuilder<RegisterFormBloc, RegisterFormState>(
      builder: (context, state) {
        return AbstractPasswordField(
          fieldTitle: 'Confirm Password',
          controller: controller,
          unauthenticatedStatus: UnauthenticatedStatus.passwordMismatch,
          errorText: 'Passwords don\'t match',
          hintText: 'Retype your password',
          isVisible: state.isConfirmPasswordVisible,
          onVisibilityToggle: () {
            context.read<RegisterFormBloc>().add(ToggleRegisterConfirmPasswordVisibilityEvent());
          },
        );
      },
    );
  }

  Widget _submitButton(BuildContext context) {
    return PrimaryButton(
      text: 'Register',
      textColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.primary,
      onPressed:
          () =>
              _areTextFieldsEmpty(context)
                  ? _showErrorSnackbar(context)
                  : _fireRegisterEvent(context),
    );
  }

  bool _areTextFieldsEmpty(BuildContext context) {
    final formData = RegisterFormData.of(context)!;
    return formData.name.isEmpty ||
        formData.email.isEmpty ||
        formData.password.isEmpty ||
        formData.confirmPassword.isEmpty;
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

  void _fireRegisterEvent(BuildContext context) {
    final formData = RegisterFormData.of(context)!;
    final userMap = {'name': formData.name, 'email': formData.email};
    context.read<AuthBloc>().add(
      RegisterEvent(
        userMap: userMap,
        password: formData.password,
        confirmPassword: formData.confirmPassword,
      ),
    );
  }

  Widget _signInRedirect(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Already have an account?', style: GoogleFonts.merriweather(fontSize: 20)),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(ResetAuthStateEvent());
              context.go('/login');
            },
            child: Text(
              'Sign in',
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
