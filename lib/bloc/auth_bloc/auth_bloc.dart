import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/core/errors/exceptions.dart';
import 'package:task_manager/data/repository/auth_repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required authRepository}) : _authRepository = authRepository, super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<AuthSubscriptionEvent>(_onAuthSubscription);
    on<ResetAuthStateEvent>(_onResetAuthState);
  }

  Future<void> _onResetAuthState(ResetAuthStateEvent event, Emitter<AuthState> emit) async {
    emit(AuthInitial());
  }

  Future<void> _onAuthSubscription(AuthSubscriptionEvent event, Emitter<AuthState> emit) async {
    await emit.forEach(
      _authRepository.getAuthStream(),
      onData: (user) {
        if (user == null) {
          return Unauthenticated(UnauthenticatedStatus.initial);
        } else {
          return Authenticated(authenticatedUser: user);
        }
      },
    );
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      await _authRepository.register(event.userMap, event.password, event.confirmPassword);
      emit(Authenticated(authenticatedUser: _authRepository.loggedUser));
    } catch (e) {
      final exceptionMapping = <Type, UnauthenticatedStatus>{
        PasswordMismatchException: UnauthenticatedStatus.passwordMismatch,
        WeakPasswordException: UnauthenticatedStatus.weakPassword,
        EmailAlreadyInUseException: UnauthenticatedStatus.duplicateEmail,
        BadEmailFormatException: UnauthenticatedStatus.badEmailFormat,
      };
      
      final status = exceptionMapping[e.runtimeType] ?? UnauthenticatedStatus.unknownError;
      emit(Unauthenticated(status));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      await _authRepository.login(event.email, event.password);
      emit(Authenticated(authenticatedUser: _authRepository.loggedUser));
    } catch (e) {
      final exceptionMapping = <Type, UnauthenticatedStatus>{
        InvalidCredentialsException: UnauthenticatedStatus.invalidCredentials,
        BadEmailFormatException: UnauthenticatedStatus.badEmailFormat,
      };

      final status = exceptionMapping[e.runtimeType] ?? UnauthenticatedStatus.unknownError;
      emit(Unauthenticated(status));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _authRepository.logout();
    emit(Unauthenticated(UnauthenticatedStatus.initial));
  }
}
