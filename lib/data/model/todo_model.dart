import 'package:equatable/equatable.dart';

class TodoModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String dueDate;
  final String time;
  final bool isCompleted;

  const TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.time,
    required this.isCompleted,
  });

  static TodoModel fromMap(Map<String, dynamic> data) {
    return TodoModel(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      dueDate: data['dueDate'],
      time: data['time'],
      isCompleted: data['isCompleted'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'time': time,
      'isCompleted': isCompleted,
    };
  }

  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    String? dueDate,
    String? time,
    bool? isCompleted,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      time: time ?? this.time,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, title, description, dueDate, time, isCompleted];
}
