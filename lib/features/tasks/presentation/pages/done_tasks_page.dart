import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_app_clean_architecture/features/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:tasks_app_clean_architecture/features/tasks/presentation/cubit/tasks_state.dart';
import 'package:tasks_app_clean_architecture/features/tasks/presentation/widgets/build_tasks_Item.dart';

class DoneTasksPage extends StatelessWidget {
  const DoneTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubit, TasksState>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = TasksCubit.get(context).donetasks;
        return ListView.separated(
          itemBuilder: (context, index) => BuildTasksItem(tasks: tasks[index]),
          separatorBuilder: (context, index) =>
              const Divider(color: Colors.grey, thickness: 1),
          itemCount: tasks.length,
        );
      },
    );
  }
}
