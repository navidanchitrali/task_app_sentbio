import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app_sentbio/domain/entities/simple_task.dart';
import 'package:note_app_sentbio/domain/entities/timed_task.dart';
import 'package:note_app_sentbio/presentation/task/task_bloc.dart';
import 'package:note_app_sentbio/presentation/task/task_event.dart';
import 'package:note_app_sentbio/presentation/task/task_state.dart';
import 'package:note_app_sentbio/repositories/task_repository_impl.dart';
import 'package:uuid/uuid.dart';

 

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TaskBloc(TaskRepositoryImpl())..add(LoadTasks()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Task Manager')),
        body: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state.tasks.isEmpty) {
              return const Center(child: Text('No tasks yet'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return Card(
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.description),
                    trailing: Checkbox(
                      value: task.isCompleted,
                      onChanged: task.isCompleted
                          ? null
                          : (_) {
                              context
                                  .read<TaskBloc>()
                                  .add(CompleteTask(task));
                            },
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addTask(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _addTask(BuildContext context) {
    final id = const Uuid().v4();

    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Simple Task'),
            onTap: () {
              context.read<TaskBloc>().add(
                    AddTask(
                      SimpleTask(
                        id: id,
                        title: 'Simple Task',
                        description: 'Can complete anytime',
                      ),
                    ),
                  );
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Timed Task'),
            onTap: () {
              context.read<TaskBloc>().add(
                    AddTask(
                      TimedTask(
                        id: id,
                        title: 'Timed Task',
                        description: 'Complete after 10 seconds',
                        dueTime:
                            DateTime.now().add(const Duration(seconds: 10)),
                      ),
                    ),
                  );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
