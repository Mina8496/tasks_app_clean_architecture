import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:tasks_app_clean_architecture/features/tasks/presentation/widgets/build_tasks_Item.dart';

class TasksBuilder extends StatelessWidget {
  final List<Map> tasks;
  const TasksBuilder({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) => BuildTasksItem(tasks: tasks[index]),
        separatorBuilder: (context, index) =>
            const Divider(color: Colors.grey, thickness: 1),
        itemCount: tasks.length,
      ),
      fallback: (context) => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu, size: 100, color: Colors.grey),
            Text(
              'No Tasks Yet, Please Add Some Tasks',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
