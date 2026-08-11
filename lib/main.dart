import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:tasks_app_clean_architecture/features/tasks/presentation/cubit/MyBlocObserver.dart';
import 'features/tasks/presentation/pages/tasks_home_page.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TasksApp());
}

class TasksApp extends StatelessWidget {
  const TasksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home:  TasksHomePage(),
    );
  }
}
