import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_form_event.dart';
part 'login_form_state.dart';

class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  LoginFormBloc() : super(LoginFormState()) {
    on<ToggleLoginPasswordVisibilityEvent>(_onToggleLoginPasswordVisibility);
  }

  void _onToggleLoginPasswordVisibility(
    ToggleLoginPasswordVisibilityEvent event,
    Emitter<LoginFormState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }
}
