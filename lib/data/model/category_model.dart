import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String id;
  final String name;

  const CategoryModel({required this.id, required this.name});

  static CategoryModel fromMap(Map<String, dynamic> data) {
    return CategoryModel(id: data['id'], name: data['name']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  CategoryModel copyWith({String? id, String? name}) {
    return CategoryModel(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  List<Object?> get props => [id, name];
}
