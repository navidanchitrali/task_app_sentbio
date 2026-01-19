// data/repositories/task_repository_impl.dart - Updated
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final List<Task> _tasks = [];

  @override
  List<Task> getTasks() {
    // Create a copy of the list and sort it
    final List<Task> sortedTasks = List.from(_tasks);
    
    sortedTasks.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1; // Incomplete first
      }
      return b.createdAt.compareTo(a.createdAt); // Newest first
    });
    
    return List.unmodifiable(sortedTasks);
  }

  @override
  void addTask(Task task) {
    _tasks.add(task);
  }

  @override
  void updateTask(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
  }
}