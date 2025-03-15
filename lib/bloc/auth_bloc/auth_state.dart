part of 'auth_bloc.dart';

enum UnauthenticatedStatus { unknownError, initial, passwordMismatch, weakPassword, duplicateEmail, badEmailFormat, invalidCredentials }

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class Authenticated extends AuthState {
  final User authenticatedUser;

  const Authenticated({required this.authenticatedUser});

  @override
  List<Object> get props => [authenticatedUser];
}

final class Unauthenticated extends AuthState {
  final UnauthenticatedStatus status;

  const Unauthenticated(this.status);

  @override
  List<Object> get props => [status];
}

final class AuthLoading extends AuthState {}
