import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/core/errors/exceptions.dart';
import 'package:task_manager/data/repository/auth_repository/firebase_auth_repository.dart';
import 'package:task_manager/data/repository/user_repository/firebase_user_repository.dart';
import 'package:task_manager/firebase_options.dart';

void main() {
  group('test auth repository', () {
    late FirebaseFirestore firestore;
    late FirebaseAuth firebaseAuth;
    late FirebaseUserRepository userRepository;
    late FirebaseAuthRepository authRepository;

    Future<void> clearFirebase() async {
      final user = firebaseAuth.currentUser;
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
    });

    group('test auth stream', () {
      late Map<String, dynamic> userModel;

      setUp(() async {
        userModel = {'name': 'tony', 'email': 'tony@gmail.com'};
      });

      test('auth stream should initially emit null', () {
        expect(authRepository.getAuthStream(), emitsInOrder([null]));
      });

      test('auth stream should emit user upon registration', () async {
        expect(authRepository.getAuthStream(), emitsInOrder([null, isA<User>()]));
        await authRepository.register(userModel, 'test123', 'test123');
        await clearFirebase();
      });

      test('auth stream should emit null, user, null, user', () async {
        expect(
          authRepository.getAuthStream(),
          emitsInOrder([null, isA<User>(), null, isA<User>()]),
        );
        await authRepository.register(userModel, 'test123', 'test123');
        await authRepository.logout();
        await authRepository.login(userModel['email'], 'test123');
        await clearFirebase();
      });
    });

    group('test register without exceptions', () {
      test('should register new user', () async {
        await authRepository.register(
          {'name': 'tony', 'email': 'tony@gmail.com'},
          'test123',
          'test123',
        );
        final userId = firebaseAuth.currentUser?.uid;
        final docSnapshot = await firestore.collection('users').doc(userId).get();
        final data = docSnapshot.data()!;
        expect(data['name'], 'tony');
        expect(data['email'], 'tony@gmail.com');
        await clearFirebase();
      });
    });

    group('test register with exceptions', () {
      test('should throw EmailAlreadyInUseException', () async {
        await authRepository.register(
          {'name': 'tony', 'email': 'tony@gmail.com'},
          'test123',
          'test123',
        );
        expect(
          () async => await authRepository.register(
            {'name': 'tony', 'email': 'tony@gmail.com'},
            'test123',
            'test123',
          ),
          throwsA(isA<EmailAlreadyInUseException>()),
        );
        await clearFirebase();
      });

      test('should throw PasswordMismatchException', () {
        expect(
          () async => await authRepository.register(
            {'name': 'tony', 'email': 'tony@gmail.com'},
            'test123',
            'test1234',
          ),
          throwsA(isA<PasswordMismatchException>()),
        );
      });

      test('should throw WeakPasswordException', () {
        expect(
          () async => await authRepository.register(
            {'name': 'tony', 'email': 'tony@gmail.com'},
            '123',
            '123',
          ),
          throwsA(isA<WeakPasswordException>()),
        );
      });

      test('should throw BadEmailFormatException', () {
        expect(
          () async => await authRepository.register(
            {'name': 'tony', 'email': 'tonygmail.com'},
            'test123',
            'test123',
          ),
          throwsA(isA<BadEmailFormatException>()),
        );
      });
    });

    group('test login without exceptions', () {
      test('should login registered user', () async {
        await authRepository.register(
          {'name': 'tony', 'email': 'tony@gmail.com'},
          'test123',
          'test123',
        );
        await authRepository.login('tony@gmail.com', 'test123');
        final userId = firebaseAuth.currentUser?.uid;
        final docSnapshot = await firestore.collection('users').doc(userId).get();
        final data = docSnapshot.data()!;
        expect(data['name'], 'tony');
        expect(data['email'], 'tony@gmail.com');
        await clearFirebase();
      });
    });

    group('test login with exceptions', () {
      test('should throw BadEmailFormatException', () {
        expect(
          () async => await authRepository.login('tonyemail.com', 'test123'),
          throwsA(isA<BadEmailFormatException>()),
        );
      });

      test('should throw InvalidCredentialsException if email is not registered', () {
        expect(
          () async => await authRepository.login('quentin@email.com', 'test123'),
          throwsA(isA<InvalidCredentialsException>()),
        );
      });

      test('should throw InvalidCredentialsException if password is wrong', () async {
        await authRepository.register(
          {'name': 'tony', 'email': 'tony@gmail.com'},
          'test123',
          'test123',
        );
        await authRepository.logout();
        expect(
          () async => await authRepository.login('tony@email.com', 'test1234'),
          throwsA(isA<InvalidCredentialsException>()),
        );
        await authRepository.login('tony@gmail.com', 'test123');
        await clearFirebase();
      });
    });

    group('test logout', () {
      test('should return null current user', () async {
        await authRepository.register(
          {'name': 'tony', 'email': 'tony@gmail.com'},
          'test123',
          'test123',
        );
        expect(firebaseAuth.currentUser, isNotNull);
        await authRepository.logout();
        expect(firebaseAuth.currentUser, isNull);
        await authRepository.login('tony@gmail.com', 'test123');
        await clearFirebase();
      });
    });
  });
}
