import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/shared/widgets/primary_button.dart';
import 'package:task_manager/view/categories/util/category_form_data.dart';

class CategoryFormWidget extends StatelessWidget {
  const CategoryFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: _categoryFormContainer(context),
      ),
    );
  }

  Widget _categoryFormContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: _CategoryForm(),
    );
  }
}

class _CategoryForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CategoryFormState();
  }
}

class _CategoryFormState extends State<_CategoryForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CategoryFormData(
      nameController: _nameController,
      child: Form(key: _formKey, child: _FormContent()),
    );
  }
}

class _FormContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        _handle(),
        const SizedBox(height: 40),
        _nameField(context),
        const SizedBox(height: 40),
        _submitButton(context),
      ],
    );
  }

  Widget _handle() {
    return Container(
      width: 100,
      height: 5,
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _nameField(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_categoryFieldTitle(), _categoryField(context)],
      ),
    );
  }

  Widget _categoryFieldTitle() {
    return Text('Category', style: GoogleFonts.merriweather(fontSize: 20));
  }

  Widget _categoryField(BuildContext context) {
    return SizedBox(
      height: 30,
      child: TextFormField(
        controller: CategoryFormData.of(context)!.nameController,
        decoration: InputDecoration(hintText: 'Enter category name'),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return PrimaryButton(
      text: 'Create',
      textColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.primary,
      onPressed:
          () =>
              _isCategoryNameFieldEmpty(context)
                  ? _showErrorSnackbar(context)
                  : _fireRegisterEvent(context),
    );
  }

  bool _isCategoryNameFieldEmpty(BuildContext context) {
    final categoryFormData = CategoryFormData.of(context)!;
    return categoryFormData.name.isEmpty;
  }

  void _showErrorSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You cannot leave the field empty'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _fireRegisterEvent(BuildContext context) {
    final categoryFormData = CategoryFormData.of(context)!;
    Navigator.pop(context, categoryFormData.name);
  }
}
