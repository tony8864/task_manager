part of 'register_form_bloc.dart';

enum RegisterFormStatus { initial, success, weakPassword, mismatchPassword, duplicateEmail }

class RegisterFormState extends Equatable {
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final RegisterFormStatus status;
  final String errorMsg;

  const RegisterFormState({
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.status = RegisterFormStatus.initial,
    this.errorMsg = '',
  });

  RegisterFormState copyWith({
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    RegisterFormStatus? status,
    String? errorMsg,
  }) {
    return RegisterFormState(
      errorMsg: errorMsg ?? this.errorMsg,
      isConfirmPasswordVisible: isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [isPasswordVisible, isConfirmPasswordVisible, status, errorMsg];
}
