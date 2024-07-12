import 'package:flutter/material.dart';
import 'package:task_management_app/models/task.dart';

class QuadrantPanel extends StatelessWidget {
  final List<Task> tasks;

  const QuadrantPanel({Key? key, required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        Task task = tasks[index];
        return ListTile(
          title: Text(task.taskName),
          subtitle: Text(task.description ?? ''),
        );
      },
    );
  }
}
