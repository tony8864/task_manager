import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/shared/widgets/primary_button.dart';
import 'package:task_manager/view/todos/util/todo_form_data.dart';
import 'package:task_manager/view/todos/widgets/todo_description_field.dart';
import 'package:task_manager/view/todos/widgets/todo_due_date_field.dart';
import 'package:task_manager/view/todos/widgets/todo_form_title_field.dart';
import 'package:task_manager/view/todos/widgets/todo_time_field.dart';

class TodoFormWidget extends StatelessWidget {
  const TodoFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 100,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: _todoFormContainer(context),
      ),
    );
  }

  Widget _todoFormContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height - 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: _TodoForm(),
    );
  }
}

class _TodoForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TodoFromState();
  }
}

class _TodoFromState extends State<_TodoForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _timeController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dueDateController.text = DateFormat('MMMM d, y').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TodoFormData(
      titleController: _titleController,
      descriptionController: _descriptionController,
      dueDateController: _dueDateController,
      timeController: _timeController,
      child: Form(key: _formKey, child: _FormContent(onPickDate: _selectDate)),
    );
  }
}

class _FormContent extends StatelessWidget {
  final Future<void> Function() _onPickDate;

  const _FormContent({required onPickDate}) : _onPickDate = onPickDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 1),
        _handle(),
        const Spacer(flex: 2),
        TodoFormTitleField(),
        const Spacer(flex: 1),
        TodoTimeField(),
        const Spacer(flex: 1),
        TodoDueDate(onPickDate: _onPickDate),
        const Spacer(flex: 1),
        TodoDescriptionField(),
        const Spacer(flex: 2),
        _submitButton(context),
        const Spacer(flex: 3),
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

  Widget _submitButton(BuildContext context) {
    return PrimaryButton(
      text: 'Create',
      textColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.primary,
      onPressed:
          () =>
              _areTodoFieldsEmpty(context)
                  ? _showErrorSnackbar(context)
                  : _fireRegisterEvent(context),
    );
  }

  bool _areTodoFieldsEmpty(BuildContext context) {
    return _isTodoTitleFieldEmpty(context) ||
        _isTodoDueDateFieldEmpty(context) ||
        _isTodoTimeFieldEmpty(context) ||
        _isTodoDescriptionFieldEmpty(context);
  }

  bool _isTodoTitleFieldEmpty(BuildContext context) {
    final todoFormData = TodoFormData.of(context)!;
    return todoFormData.title.isEmpty;
  }

  bool _isTodoDueDateFieldEmpty(BuildContext context) {
    final todoFormData = TodoFormData.of(context)!;
    return todoFormData.dueDate.isEmpty;
  }

  bool _isTodoTimeFieldEmpty(BuildContext context) {
    final todoFormData = TodoFormData.of(context)!;
    return todoFormData.time.isEmpty;
  }

  bool _isTodoDescriptionFieldEmpty(BuildContext context) {
    final todoFormData = TodoFormData.of(context)!;
    return todoFormData.description.isEmpty;
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
    final todoFormData = TodoFormData.of(context)!;
    final title = todoFormData.title;
    final dueDate = todoFormData.dueDate;
    final time = todoFormData.time;
    final description = todoFormData.description;

    final todoMap = {'title': title, 'description': description, 'dueDate': dueDate, 'time': time};
    Navigator.pop(context, todoMap);
  }
}
