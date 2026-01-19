import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app_sentbio/presentation/task/task_bloc.dart';
import 'package:note_app_sentbio/presentation/task/task_event.dart';
import 'package:note_app_sentbio/repositories/task_repository_impl.dart';
import 'presentation/screens/task/task_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskBloc(TaskRepositoryImpl())..add(LoadTasks()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const TaskScreen(),
      ),
    );
  }
}
