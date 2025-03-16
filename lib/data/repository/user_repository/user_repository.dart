import 'package:task_manager/data/model/user_model.dart';

abstract class UserRepository {
  Future<String?> get username;
  Future<void> addUser(Map<String, dynamic> userMap);
  Future<void> updateUser(UserModel user);
}