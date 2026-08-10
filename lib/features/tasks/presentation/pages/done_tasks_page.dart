import 'package:flutter/material.dart';

class DoneTasksPage extends StatelessWidget {
  const DoneTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Done Tasks',
        style: TextStyle(
          color: Color(0xFF202124),
          fontSize: 27,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
