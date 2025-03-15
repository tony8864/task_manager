import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/bloc/register_form_bloc/register_form_bloc.dart';

void main() {
  group('RegisterFormBloc', () {
    late RegisterFormBloc registerFormBloc;

    setUp(() {
      registerFormBloc = RegisterFormBloc();
    });

    tearDown(() {
      registerFormBloc.close();
    });

    blocTest<RegisterFormBloc, RegisterFormState>(
      'emits state with toggled isPasswordVisible when ToggleRegisterPasswordVisibilityEvent is added',
      build: () => registerFormBloc,
      act: (bloc) => bloc.add(ToggleRegisterPasswordVisibilityEvent()),
      expect: () => [
        isA<RegisterFormState>().having((e) => e.isPasswordVisible, 'isPasswordVisible', true),
      ],
    );

    blocTest<RegisterFormBloc, RegisterFormState>(
      'emits state with multiple toggled isPasswordVisible when ToggleRegisterPasswordVisibilityEvent is added',
      build: () => registerFormBloc,
      act: (bloc) {
        bloc.add(ToggleRegisterPasswordVisibilityEvent());
        bloc.add(ToggleRegisterPasswordVisibilityEvent());
        bloc.add(ToggleRegisterPasswordVisibilityEvent());
        bloc.add(ToggleRegisterPasswordVisibilityEvent());
      },
      expect: () => [
        isA<RegisterFormState>().having((e) => e.isPasswordVisible, 'isPasswordVisible', true),
        isA<RegisterFormState>().having((e) => e.isPasswordVisible, 'isPasswordVisible', false),
        isA<RegisterFormState>().having((e) => e.isPasswordVisible, 'isPasswordVisible', true),
        isA<RegisterFormState>().having((e) => e.isPasswordVisible, 'isPasswordVisible', false),
      ],
    );

    blocTest<RegisterFormBloc, RegisterFormState>(
      'emits state with toggled isConfirmPasswordVisible when ToggleRegisterConfirmPasswordVisibilityEvent is added',
      build: () => registerFormBloc,
      act: (bloc) => bloc.add(ToggleRegisterConfirmPasswordVisibilityEvent()),
      expect: () => [
        isA<RegisterFormState>().having((e) => e.isConfirmPasswordVisible, 'isConfirmPasswordVisible', true),
      ],
    );
  });
}
