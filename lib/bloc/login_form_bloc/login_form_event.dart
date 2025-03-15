part of 'login_form_bloc.dart';

sealed class LoginFormEvent extends Equatable {
  const LoginFormEvent();

  @override
  List<Object> get props => [];
}

class ToggleLoginPasswordVisibilityEvent extends LoginFormEvent {}
