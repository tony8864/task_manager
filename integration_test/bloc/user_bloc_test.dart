import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:task_manager/bloc/user_bloc/user_bloc.dart';
import 'package:task_manager/data/model/user_model.dart';
import 'package:task_manager/data/repository/auth_repository/firebase_auth_repository.dart';
import 'package:task_manager/data/repository/user_repository/firebase_user_repository.dart';
import 'package:task_manager/firebase_options.dart';

void main() {
  group('test user bloc', () {
    late FirebaseFirestore firestore;
    late FirebaseAuth firebaseAuth;
    late FirebaseUserRepository userRepository;
    late FirebaseAuthRepository authRepository;
    late UserBloc userBloc;
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
      userBloc = UserBloc(userRepository: userRepository);
      userModelMap = {'name': 'tony', 'email': 'tony@email.com'};
    });

    group('test user update', () {
      blocTest(
        'should emit UserUpdatedSuccessfull',
        build: () => userBloc,
        setUp: () async => await authRepository.register(userModelMap, 'test123', 'test123'),
        act: (bloc) {
          final userId = firebaseAuth.currentUser?.uid;
          final updatedModel = UserModel.fromMap(
            userModelMap..addAll({'id': userId}),
          ).copyWith(name: 'quentin');
          bloc.add(UserUpdateEvent(userModel: updatedModel));
        },
        wait: const Duration(milliseconds: 2000),
        expect: () => [isA<UserLoading>(), isA<UserSuccess>()],
        tearDown: () async => await clearFirebase(),
      );

      blocTest(
        'should emit UserUpdatedFailure',
        build: () => userBloc,
        act: (bloc) {
          final updatedModel = UserModel.fromMap(
            userModelMap..addAll({'id': '1'}),
          ).copyWith(name: 'quentin');
          bloc.add(UserUpdateEvent(userModel: updatedModel));
        },
        wait: const Duration(milliseconds: 2000),
        expect: () => [isA<UserLoading>(), isA<UserFailure>()],
      );
    });
  });
}
