part of 'register_form_bloc.dart';

sealed class RegisterFormEvent extends Equatable {
  const RegisterFormEvent();

  @override
  List<Object> get props => [];
}

class ToggleRegisterPasswordVisibilityEvent extends RegisterFormEvent {}

class ToggleRegisterConfirmPasswordVisibilityEvent extends RegisterFormEvent {}