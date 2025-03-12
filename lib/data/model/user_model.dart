import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;

  const UserModel({required this.id, required this.name, required this.email});

  static UserModel fromMap(Map<String, dynamic> data) {
    return UserModel(id: data['id'], name: data['name'], email: data['email']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email};
  }

  UserModel copyWith({String? id, String? name, String? email}) {
    return UserModel(id: id ?? this.id, name: name ?? this.name, email: email ?? this.email);
  }

  @override
  List<Object?> get props => [id, name, email];
}
