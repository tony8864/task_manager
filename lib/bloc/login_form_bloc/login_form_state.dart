part of 'login_form_bloc.dart';

enum RegisterFormStatus { initial, success, failure }

class LoginFormState extends Equatable {
  final bool isPasswordVisible;
  final RegisterFormStatus status;
  final String errorMsg;

  const LoginFormState({
    this.isPasswordVisible = false,
    this.status = RegisterFormStatus.initial,
    this.errorMsg = '',
  });

  LoginFormState copyWith({bool? isPasswordVisible, RegisterFormStatus? status, String? errorMsg}) {
    return LoginFormState(
      errorMsg: errorMsg ?? this.errorMsg,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [isPasswordVisible, status, errorMsg];
}
