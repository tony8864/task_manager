import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager/data/model/user_model.dart';
import 'package:task_manager/data/repository/user_repository/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc({required userRepository}) : _userRepository = userRepository, super(UserInitial()) {
    on<UserUpdateEvent>(_onUserUpate);
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
}
