// presentation/task/task_bloc.dart - Simplified
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc(this.repository) : super(const TaskState([])) {
    on<LoadTasks>((event, emit) {
      final tasks = repository.getTasks(); // Already sorted
      emit(TaskState(tasks));
    });

    on<AddTask>((event, emit) {
      repository.addTask(event.task);
      final tasks = repository.getTasks(); // Get sorted list
      emit(TaskState(tasks));
    });

    on<CompleteTask>((event, emit) {
      if (event.task.canComplete() && !event.task.isCompleted) {
        final completedTask = event.task.copyWith(isCompleted: true);
        repository.updateTask(completedTask);
        final tasks = repository.getTasks(); // Get sorted list
        emit(TaskState(tasks));
      } else if (!event.task.canComplete()) {
        // Business rule violation - show error in UI
        // For now, we'll just not update
        print('Cannot complete task before due time');
      }
    });
  }
}