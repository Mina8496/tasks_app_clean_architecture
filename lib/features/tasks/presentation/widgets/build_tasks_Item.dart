import 'package:flutter/material.dart';
import 'package:tasks_app_clean_architecture/features/tasks/presentation/cubit/tasks_cubit.dart';

class BuildTasksItem extends StatelessWidget {
  final Map tasks;
  const BuildTasksItem({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            child: Text(
              '${tasks['time']}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${tasks['title']}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${tasks['data']}',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                SizedBox(width: 20),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              TasksCubit.get(
                context,
              ).updateData(status: 'done', id: tasks['id']);
            },
            icon: Icon(Icons.check_box, color: Colors.green),
          ),
          IconButton(
            onPressed: () {
              TasksCubit.get(
                context,
              ).updateData(status: 'archived', id: tasks['id']);
            },
            icon: Icon(Icons.archive, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}
