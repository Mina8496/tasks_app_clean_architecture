import 'package:flutter/material.dart';
import 'features/tasks/presentation/pages/tasks_home_page.dart';

void main() {
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
      home: const TasksHomePage(),
    );
  }
}
