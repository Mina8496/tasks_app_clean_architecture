import 'package:flutter/material.dart';

class ArchivedTasksPage extends StatelessWidget {
  const ArchivedTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Archived Tasks',
        style: TextStyle(
          color: Color(0xFF202124),
          fontSize: 27,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
