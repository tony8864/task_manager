import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'register_form_event.dart';
part 'register_form_state.dart';

class RegisterFormBloc extends Bloc<RegisterFormEvent, RegisterFormState> {
  RegisterFormBloc() : super(RegisterFormState()) {
    on<ToggleRegisterPasswordVisibilityEvent>(_onTogglePasswordVisibility);
    on<ToggleRegisterConfirmPasswordVisibilityEvent>(_onToggleConfirmPassword);
  }

  void _onTogglePasswordVisibility(
    ToggleRegisterPasswordVisibilityEvent event,
    Emitter<RegisterFormState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible, status: RegisterFormStatus.success));
  }

  void _onToggleConfirmPassword(
    ToggleRegisterConfirmPasswordVisibilityEvent event,
    Emitter<RegisterFormState> emit,
  ) {
    emit(state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible, status: RegisterFormStatus.success));
  }
}
