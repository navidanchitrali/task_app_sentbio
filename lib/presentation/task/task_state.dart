import 'package:equatable/equatable.dart';
import '../../../domain/entities/task.dart';

class TaskState extends Equatable {
  final List<Task> tasks;

  const TaskState(this.tasks);

  @override
  List<Object?> get props => [tasks];
}
