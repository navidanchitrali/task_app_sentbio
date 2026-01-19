// presentation/screens/task/task_screen.dart - Updated
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:note_app_sentbio/domain/entities/simple_task.dart';
import 'package:note_app_sentbio/domain/entities/task.dart';
import 'package:note_app_sentbio/domain/entities/timed_task.dart';
import 'package:note_app_sentbio/presentation/task/task_bloc.dart';
import 'package:note_app_sentbio/presentation/task/task_event.dart';
import 'package:note_app_sentbio/presentation/task/task_state.dart';
import 'package:uuid/uuid.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Task Manager',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state.tasks.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<TaskBloc>().add(LoadTasks());
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.tasks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return _buildTaskCard(context, task);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskDialog(context),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('New Task'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'No tasks yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tap + to create your first task',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task) {
    final isTimedTask = task is TimedTask;
    final canComplete = task.canComplete();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: task.isCompleted ? Colors.grey : Colors.black,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
                Row(
                  children: [
                    if (isTimedTask)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.blue[700],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Timed',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(width: 8),
                    Checkbox(
                      value: task.isCompleted,
                      onChanged: !task.isCompleted && canComplete
                          ? (_) {
                              context.read<TaskBloc>().add(CompleteTask(task));
                            }
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      activeColor: Colors.deepPurple,
                    ),
                  ],
                ),
              ],
            ),
            if (task.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                task.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ],
            if (isTimedTask) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: canComplete ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 8),
                 Column(children: [
                   Text(
                    'Due: ${DateFormat('MMM dd, yyyy HH:mm').format((task as TimedTask).dueTime)}',
                    style: TextStyle(
                      fontSize: 13,
                      color: canComplete ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (!canComplete)
                    Text(
                      '(Wait until due time)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                 ],)
                ],
              ),
            ],
            const SizedBox(height: 4),
            Text(
              'Created: ${DateFormat('MMM dd, yyyy').format(task.createdAt)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

void _showAddTaskDialog(BuildContext context) {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDueTime;
  String? selectedTaskType; // 'simple' or 'timed'

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create New Task',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Task Title
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Task Title',
                      hintText: 'Enter task title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.title),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Task Description
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description (optional)',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.description),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Task Type Selection
                  const Text(
                    'Select Task Type:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Simple Task'),
                          selected: selectedTaskType == 'simple',
                          onSelected: (selected) {
                            setState(() {
                              selectedTaskType = selected ? 'simple' : null;
                            });
                          },
                          avatar: const Icon(Icons.task_outlined, size: 18),
                          backgroundColor: Colors.grey[100],
                          selectedColor: Colors.blue[100],
                          labelStyle: TextStyle(
                            color: selectedTaskType == 'simple' 
                              ? Colors.blue[800] 
                              : Colors.grey[800],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Timed Task'),
                          selected: selectedTaskType == 'timed',
                          onSelected: (selected) {
                            setState(() {
                              selectedTaskType = selected ? 'timed' : null;
                            });
                          },
                          avatar: const Icon(Icons.access_time, size: 18),
                          backgroundColor: Colors.grey[100],
                          selectedColor: Colors.orange[100],
                          labelStyle: TextStyle(
                            color: selectedTaskType == 'timed' 
                              ? Colors.orange[800] 
                              : Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Due Date Picker (only for timed tasks)
                  if (selectedTaskType == 'timed') ...[
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.orange[700],
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            selectedDueTime == null
                              ? 'No due time selected'
                              : 'Due: ${DateFormat('MMM dd, yyyy HH:mm').format(selectedDueTime!)}',
                            style: TextStyle(
                              color: selectedDueTime == null
                                ? Colors.grey[600]
                                : Colors.orange[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final pickedDateTime = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now().add(
                                const Duration(days: 1),
                              ),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            
                            if (pickedDateTime != null) {
                              final pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              
                              if (pickedTime != null) {
                                setState(() {
                                  selectedDueTime = DateTime(
                                    pickedDateTime.year,
                                    pickedDateTime.month,
                                    pickedDateTime.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  );
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[50],
                            foregroundColor: Colors.orange[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            selectedDueTime == null
                              ? 'Set Due Time'
                              : 'Change Time',
                          ),
                        ),
                      ],
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: Colors.grey[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (titleController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a task title'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            
                            if (selectedTaskType == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select a task type'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            
                            if (selectedTaskType == 'timed' && selectedDueTime == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please set a due time for timed task'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            
                            final taskId = const Uuid().v4();
                            
                            if (selectedTaskType == 'simple') {
                              context.read<TaskBloc>().add(
                                AddTask(
                                  SimpleTask(
                                    id: taskId,
                                    title: titleController.text.trim(),
                                    description: descriptionController.text.trim(),
                                    createdAt: DateTime.now(),
                                  ),
                                ),
                              );
                            } else if (selectedTaskType == 'timed') {
                              context.read<TaskBloc>().add(
                                AddTask(
                                  TimedTask(
                                    id: taskId,
                                    title: titleController.text.trim(),
                                    description: descriptionController.text.trim(),
                                    createdAt: DateTime.now(),
                                    dueTime: selectedDueTime!,
                                  ),
                                ),
                              );
                            }
                            
                            Navigator.pop(dialogContext);
                            _showSuccessSnackbar(context, selectedTaskType!);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Create Task'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
  void _showSuccessSnackbar(BuildContext context, String taskType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$taskType created successfully!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}