import 'package:flutter/material.dart';
import 'package:tasks_app_clean_architecture/core/constant/constants.dart';
import 'package:tasks_app_clean_architecture/features/tasks/presentation/widgets/build_tasks_Item.dart';

class NewTasksPage extends StatelessWidget {
  const NewTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => BuildTasksItem(tasks: tasks[index]),
      separatorBuilder: (context, index) =>
          const Divider(color: Colors.grey, thickness: 1),
      itemCount: tasks.length,
    );
  }
}
