import 'package:flutter/material.dart';
import 'package:task_management_app/models/task.dart';
import 'package:task_management_app/helpers/task_db_helper.dart';
import 'package:task_management_app/widgets/edit_task_wdg.dart';

class DisplayTasksWidget extends StatefulWidget {
  @override
  _DisplayTasksWidgetState createState() => _DisplayTasksWidgetState();
}

class _DisplayTasksWidgetState extends State<DisplayTasksWidget> {
  late List<Task> _tasks;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _tasks = [];
    _searchController = TextEditingController();
    _fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              _filterTasks(value);
            },
            decoration: InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _tasks.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Checkbox(
                  value: _tasks[index].isCompleted == 1,
                  onChanged: (value) {
                    _toggleTaskCompletion(_tasks[index]);
                  },
                ),
                title: Text(_tasks[index].taskName),
                subtitle: Text(
                  _tasks[index].dueDate,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _navigateToEditTaskScreen(_tasks[index]);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteTask(_tasks[index]);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _fetchTasks() async {
    List<Task> tasks = await TaskService().getTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> _toggleTaskCompletion(Task task) async {
    task.isCompleted = (task.isCompleted == 0) ? 1 : 0;
    await TaskService().updateTask(task);
    _fetchTasks();
  }

  Future<void> _deleteTask(Task task) async {
    await TaskService().deleteTask(task.taskId);
    _fetchTasks();
  }

  void _filterTasks(String query) {
    if (query.isEmpty) {
      _fetchTasks();
      return;
    }
    List<Task> filteredTasks = _tasks
        .where((task) =>
            task.taskName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _tasks = filteredTasks;
    });
  }

  void _navigateToEditTaskScreen(Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return EditTaskBottomSheet(task);
      },
    ).then((_) {
      _fetchTasks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
