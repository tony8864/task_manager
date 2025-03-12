import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:task_manager/bloc/auth_bloc/auth_bloc.dart';
import 'package:task_manager/data/repository/auth_repository/firebase_auth_repository.dart';
import 'package:task_manager/data/repository/user_repository/firebase_user_repository.dart';
import 'package:task_manager/firebase_options.dart';

void main() {
  group('test auth bloc', () {
    late FirebaseFirestore firestore;
    late FirebaseAuth firebaseAuth;
    late FirebaseUserRepository userRepository;
    late FirebaseAuthRepository authRepository;
    late AuthBloc authBloc;
    late Map<String, dynamic> userModelMap;

    Future<void> clearFirebase() async {
      var user = firebaseAuth.currentUser;
      await firestore.collection('users').doc(user?.uid).delete();
      await user?.delete();
    }

    setUpAll(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    });

    setUp(() {
      firestore = FirebaseFirestore.instance;
      firebaseAuth = FirebaseAuth.instance;
      firestore.useFirestoreEmulator('localhost', 8080);
      firebaseAuth.useAuthEmulator('localhost', 9099);
      userRepository = FirebaseUserRepository();
      authRepository = FirebaseAuthRepository(userRepository: userRepository);
      authBloc = AuthBloc(authRepository: authRepository);
      userModelMap = {'name': 'tony', 'email': 'tony@email.com'};
    });

    test('should emit initial auth state', () {
      expect(authBloc.state, isA<AuthInitial>());
    });

    group('test auth subscription event', () {
      blocTest(
        'should emit Unauthenticated when user is not signed in',
        build: () => authBloc,
        act: (bloc) => bloc.add(AuthSubscriptionEvent()),
        wait: const Duration(milliseconds: 2000),
        expect: () => [isA<Unauthenticated>()],
      );

      blocTest(
        'should emit Authenticated when user is signed in',
        build: () => authBloc,
        setUp: () async => await authRepository.register(userModelMap, 'test123', 'test123'),
        act: (bloc) => bloc.add(AuthSubscriptionEvent()),
        wait: const Duration(milliseconds: 2000),
        expect: () => [isA<Authenticated>()],
        tearDown: () async => await clearFirebase(),
      );

      blocTest(
        'should emit alternating auth states',
        build: () => authBloc,
        act: (bloc) async {
          bloc.add(AuthSubscriptionEvent());
          await authRepository.register(userModelMap, 'test123', 'test123');
          await authRepository.logout();
          await authRepository.login(userModelMap['email'], 'test123');
        },
        wait: const Duration(milliseconds: 2000),
        expect:
            () => [
              isA<Unauthenticated>(),
              isA<Authenticated>(),
              isA<Unauthenticated>(),
              isA<Authenticated>(),
            ],
        tearDown: () async => await clearFirebase(),
      );
    });

    group('test logout event', () {
      blocTest(
        'should emit Unauthenticated',
        build: () => authBloc,
        setUp: () async => await authRepository.register(userModelMap, 'test123', 'test123'),
        act: (bloc) => bloc.add(LogoutEvent()),
        wait: const Duration(milliseconds: 2000),
        expect: () => [isA<AuthLoading>(), isA<Unauthenticated>()],
        tearDown: () async {
          await authRepository.login(userModelMap['email'], 'test123');
          await clearFirebase();
        },
      );
    });

    group('test register event', () {
      blocTest(
        'should emit Authenticated on user register',
        build: () => authBloc,
        act:
            (bloc) => bloc.add(
              RegisterEvent(userMap: userModelMap, password: 'test123', confirmPassword: 'test123'),
            ),
        wait: const Duration(milliseconds: 2000),
        expect: () => [isA<AuthLoading>(), isA<Authenticated>()],
        tearDown: () async => await clearFirebase(),
      );

      blocTest(
        'should emit Unauthenticated on user register',
        build: () => authBloc,
        act:
            (bloc) => bloc.add(
              RegisterEvent(
                userMap: userModelMap,
                password: 'test123',
                confirmPassword: 'test1234',
              ),
            ),
        wait: const Duration(milliseconds: 2000),
        expect: () => [isA<AuthLoading>(), isA<Unauthenticated>()],
      );
    });

    group('test login event', () {
      blocTest(
        'should emit Auhtenticated on login',
        setUp: () async => await authRepository.register(userModelMap, 'test123', 'test123'),
        build: () => authBloc,
        act: (bloc) => bloc.add(LoginEvent(email: userModelMap['email'], password: 'test123')),
        wait: const Duration(milliseconds: 2000),
        expect: () => [isA<AuthLoading>(), isA<Authenticated>()],
        tearDown: () async => await clearFirebase(),
      );

      blocTest(
        'should emit Unauthenticated on login',
        setUp: () async => await authRepository.register(userModelMap, 'test123', 'test123'),
        build: () => authBloc,
        act: (bloc) => bloc.add(LoginEvent(email: userModelMap['email'], password: 'test1234')),
        wait: const Duration(milliseconds: 2000),
        expect: () => [isA<AuthLoading>(), isA<Unauthenticated>()],
        tearDown: () async => await clearFirebase(),
      );
    });
  });
}
