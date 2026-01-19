// domain/entities/task.dart - Updated
import 'package:equatable/equatable.dart';

abstract class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
  });

  bool canComplete();
  
  Task copyWith({
    String? title,
    String? description,
    bool? isCompleted,
  });

  @override
  List<Object?> get props => [id, title, description, isCompleted, createdAt];
}

// domain/entities/simple_task.dart
class SimpleTask extends Task {
  const SimpleTask({
    required super.id,
    required super.title,
    required super.description,
    super.isCompleted = false,
    required super.createdAt,
  });

  @override
  bool canComplete() => true; // Always can complete

  @override
  SimpleTask copyWith({
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return SimpleTask(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }
}

// domain/entities/timed_task.dart
class TimedTask extends Task {
  final DateTime dueTime;

  const TimedTask({
    required super.id,
    required super.title,
    required super.description,
    super.isCompleted = false,
    required super.createdAt,
    required this.dueTime,
  });

  @override
  bool canComplete() => DateTime.now().isAfter(dueTime);

  @override
  TimedTask copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueTime,
  }) {
    return TimedTask(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      dueTime: dueTime ?? this.dueTime,
    );
  }

  @override
  List<Object?> get props => super.props..add(dueTime);
}