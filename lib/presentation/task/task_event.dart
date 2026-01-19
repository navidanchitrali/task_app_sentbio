import 'package:equatable/equatable.dart';
import '../../../domain/entities/task.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final Task task;
  AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

class CompleteTask extends TaskEvent {
  final Task task;
  CompleteTask(this.task);

  @override
  List<Object?> get props => [task];
}
