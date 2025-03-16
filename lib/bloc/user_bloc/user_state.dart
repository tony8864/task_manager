part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

final class UserSuccess extends UserState {}

final class UserFailure extends UserState {}

final class UserLoading extends UserState {}

final class UserLoaded extends UserState {
  final String username;

  const UserLoaded(this.username);
  
  @override
  List<Object> get props => [username];
}