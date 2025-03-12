import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/core/errors/exceptions.dart';
import 'package:task_manager/data/model/user_model.dart';
import 'package:task_manager/data/repository/user_repository/firebase_user_repository.dart';
import 'package:task_manager/firebase_options.dart';

void main() {
  group('test user repository', () {
    late FirebaseFirestore firestore;
    late FirebaseAuth firebaseAuth;
    late FirebaseUserRepository userRepository;

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
    });

    group('test add user', () {
      test('should add new user to firestore', () async {
        final userMap = {'name': 'tony', 'email': 'tony@email.com'};
        await firebaseAuth.createUserWithEmailAndPassword(
          email: userMap['email']!,
          password: 'test123',
        );
        final userId = (firebaseAuth.currentUser?.uid)!;
        await userRepository.addUser(userMap..addAll({'id': userId}));
        final docSnapshot = await firestore.collection('users').doc(userId).get();
        final data = docSnapshot.data();
        expect(data?['name'], 'tony');
        expect(data?['email'], 'tony@email.com');
        await clearFirebase();
      });

      test('should throw UserNotLoggedInException', () {
        expect(
          () async => await userRepository.addUser({'name': 'tony', 'email': 'tony@email.com'}),
          throwsA(isA<UserNotLoggedInException>()),
        );
      });
    });

    group('test updateUser', () {
      test('should update users name', () async {
        final userMap = {'name': 'tony', 'email': 'tony@email.com'};
        await firebaseAuth.createUserWithEmailAndPassword(
          email: userMap['email']!,
          password: 'test123',
        );
        final userId = (firebaseAuth.currentUser?.uid)!;
        await userRepository.addUser(userMap..addAll({'id': userId}));
        var docSnapshot = await firestore.collection('users').doc(userId).get();
        var data = docSnapshot.data();
        expect(data?['name'], 'tony');
        expect(data?['email'], 'tony@email.com');

        await userRepository.updateUser(
          UserModel.fromMap({'id': userId, 'name': 'Tony', 'email': 'tony@gmail.com'}),
        );
        docSnapshot = await firestore.collection('users').doc(userId).get();
        data = docSnapshot.data();
        expect(data?['name'], 'Tony');
        expect(data?['email'], 'tony@gmail.com');
        await clearFirebase();
      });
    });
  });
}
