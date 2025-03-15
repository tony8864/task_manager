import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/bloc/login_form_bloc/login_form_bloc.dart';

void main() {
  group('LoginFormBloc', () {
    late LoginFormBloc loginFormBloc;

    setUp(() {
      loginFormBloc = LoginFormBloc();
    });

    tearDown(() {
      loginFormBloc.close();
    });

    blocTest<LoginFormBloc, LoginFormState>(
      'emits state with toggled isPasswordVisible when ToggleLoginPasswordVisibilityEvent is added',
      build: () => loginFormBloc,
      act: (bloc) => bloc.add(ToggleLoginPasswordVisibilityEvent()),
      expect:
          () => [
            isA<LoginFormState>().having((e) => e.isPasswordVisible, 'isPasswordVisible', true),
          ],
    );
  });
}
