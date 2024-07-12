import 'package:flutter/material.dart';
import 'package:task_management_app/models/task.dart';
import 'package:task_management_app/helpers/task_db_helper.dart';
import 'package:task_management_app/widgets/edit_task_wdg.dart'; 

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> tasks;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    tasks = [];
    _searchController = TextEditingController();
    _fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Center(
        title: Text('Tasks',
        style:TextStyle(
        //color: Color.fromARGB(255, 1, 25, 131),
        fontWeight:FontWeight.w900,
        fontSize: 29,
        ),
      ),
      ),
      body: Column(
        children: [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          _filterTasks(value);
        },
        decoration: InputDecoration(
          labelText: 'Search',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          filled: true,
          fillColor: Color.fromARGB(255, 210, 210, 230),
          contentPadding: EdgeInsets.symmetric(vertical: 16.5, horizontal: 16.0),
        ),
      ),
    ),
    Expanded(
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return _buildTaskItem(tasks[index]);
        },
      ),
    ),
  ],
),
    );
  }

  Widget _buildTaskItem(Task task) {
    final bool isCompleted = task.isCompleted == 1;

    return ListTile(
      title: Text(
        task.taskName,
        style: TextStyle(
          color: isCompleted ? Colors.grey : Colors.black,
          decoration: isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.description ?? ''),
          Text('Priority: ${task.priority}'),
          Text('Due Date: ${task.dueDate}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _showEditTaskBottomSheet(context, task);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteTask(task);
            },
          ),
          IconButton(
            icon: Icon(
              isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
              color: isCompleted ? Colors.green : null,
            ),
            onPressed: () {
              _toggleTaskCompletion(task);
            },
          ),
        ],
      ),
    );
  }

  void _showEditTaskBottomSheet(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return EditTaskBottomSheet(task);
      },
    ).then((value) {
      if (value != null && value) {
        _fetchTasks();
      }
    });
  }

  Future<void> _fetchTasks() async {
    List<Task> fetchedTasks = await TaskService().getTasks();
    setState(() {
      tasks = fetchedTasks;
    });
  }

  Future<void> _toggleTaskCompletion(Task task) async {
    task.isCompleted = task.isCompleted == 1 ? 0 : 1;
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
    List<Task> filteredTasks = tasks
        .where((task) =>
            task.taskName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      tasks = filteredTasks;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}