// import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager/data/model/user_model.dart';
import 'package:task_manager/data/repository/user_repository/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  String? _cachedUsername;

  UserBloc({required userRepository}) : _userRepository = userRepository, super(UserInitial()) {
    on<UserUpdateEvent>(_onUserUpate);
    on<FetchUsernameEvent>(_onFetchUsername);
  }

  Future<void> _onUserUpate(UserUpdateEvent event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      await _userRepository.updateUser(event.userModel);
      emit(UserSuccess());
    } on Exception {
      emit(UserFailure());
    }
  }

  Future<void> _onFetchUsername(FetchUsernameEvent event, Emitter<UserState> emit) async {

    if(_cachedUsername != null) {
      emit(UserLoaded(_cachedUsername!));
    } 

    try {
      emit(UserLoading());
      final username = await _userRepository.username;
      if (username == null) {
        throw UserFailure();
      }
      _cachedUsername = username;
      emit(UserLoaded(username));
    } on Exception {
      emit(UserFailure());
    }
  }
}
