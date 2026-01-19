import '../../core/enums/task_status.dart';

abstract class Task {
  final String id;
  final String title;
  final String description;
  TaskStatus _status;

  Task({
    required this.id,
    required this.title,
    required this.description,
    TaskStatus status = TaskStatus.pending,
  }) : _status = status;

  TaskStatus get status => _status;

  bool get isCompleted => _status == TaskStatus.completed;

  /// Business rule enforced here
  bool canComplete();

  /// Encapsulation
  void complete() {
    if (!canComplete()) {
      throw Exception('Task cannot be completed yet');
    }
    _status = TaskStatus.completed;
  }
}
