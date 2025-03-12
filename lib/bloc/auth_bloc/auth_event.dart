part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthSubscriptionEvent extends AuthEvent {}

final class RegisterEvent extends AuthEvent {
  final Map<String, dynamic> userMap;
  final String password;
  final String confirmPassword;

  const RegisterEvent({
    required this.userMap,
    required this.password,
    required this.confirmPassword,
  });
}

final class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});
}

final class LogoutEvent extends AuthEvent {}
