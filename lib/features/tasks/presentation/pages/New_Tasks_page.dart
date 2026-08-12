import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_app_clean_architecture/features/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:tasks_app_clean_architecture/features/tasks/presentation/cubit/tasks_state.dart';
import 'package:tasks_app_clean_architecture/features/tasks/presentation/widgets/tasks_builder.dart';

class NewTasksPage extends StatelessWidget {
  const NewTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubit, TasksState>(
      listener: (context, state) {},
      builder: (context, state) {
        final tasks = TasksCubit.get(context).newtasks;
        return TasksBuilder(tasks: tasks);
      },
    );
  }
}
