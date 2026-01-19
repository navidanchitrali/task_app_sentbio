import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc(this.repository) : super(const TaskState([])) {
    on<LoadTasks>((event, emit) {
      emit(TaskState(repository.getTasks()));
    });

    on<AddTask>((event, emit) {
      repository.addTask(event.task);
      emit(TaskState(repository.getTasks()));
    });

    on<CompleteTask>((event, emit) {
      try {
        event.task.complete();
        repository.updateTask(event.task);
        emit(TaskState(repository.getTasks()));
      } catch (_) {
        // business rule violation handled silently or via UI
      }
    });
  }
}
