part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

final class UserUpdateEvent extends UserEvent {
  final UserModel userModel;

  const UserUpdateEvent({required this.userModel});
}

final class FetchUsernameEvent extends UserEvent {}