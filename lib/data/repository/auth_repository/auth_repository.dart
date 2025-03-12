import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  User get loggedUser;
  Future<void> register(Map<String, dynamic> userMap, String password, String confirmPassword);
  Future<void> login(String email, String password);
  Stream<User?> getAuthStream();
  Future<void> logout();
  bool isLoggedIn();
}