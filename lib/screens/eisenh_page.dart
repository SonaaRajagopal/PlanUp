import 'package:flutter/material.dart';
import 'package:task_management_app/models/task.dart';
import 'package:task_management_app/helpers/task_db_helper.dart';
import 'package:task_management_app/widgets/edit_task_wdg.dart'; 
import 'package:task_management_app/widgets/edit_eisen_rank_wdg.dart'; 

class EisenhowerMatrixScreen extends StatefulWidget {
  @override
  _EisenhowerMatrixScreenState createState() => _EisenhowerMatrixScreenState();
}

class _EisenhowerMatrixScreenState extends State<EisenhowerMatrixScreen> {
  List<Task> _tasks = [];
  final Color _redLightColor = Colors.red.withOpacity(0.3);
  final Color _yellowLightColor = Color.fromARGB(255, 229, 210, 41).withOpacity(0.3);
  final Color _blueLightColor = Colors.blue.withOpacity(0.3);
  final Color _greenLightColor = Color.fromARGB(255, 61, 144, 64).withOpacity(0.3);

  @override
  void initState() {

    super.initState();
    _fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eisenhower Matrix', 
        style: TextStyle(
          color: Color.fromARGB(255, 1, 25, 131),
        fontWeight:FontWeight.w800,
        fontSize: 34,
        fontFamily: 'Kanit-SemiBoldItalic',
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: _redLightColor),
                        color: _redLightColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Urgent & Important',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(child: _buildQuadrant(1)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: _yellowLightColor),
                        color: _yellowLightColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Important,  Not Urgent',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.yellow[900], fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(child: _buildQuadrant(2)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: _blueLightColor),
                        color: _blueLightColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Urgent, Not Important',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(child: _buildQuadrant(3)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: _greenLightColor),
                        color: _greenLightColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Not Urgent & Not Important',
                              style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 52, 178, 56), fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(child: _buildQuadrant(4)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildQuadrant(int rank) {
  List<Task> quadrantTasks = _tasks.where((task) => task.eisenhowerMatrixRank == rank).toList();
  return ListView.builder(
    itemCount: quadrantTasks.length,
    itemBuilder: (context, index) {
      Task task = quadrantTasks[index];
      return ListTile(
        title: Text(task.taskName),
        subtitle: Text(task.description ?? ''),
        trailing: PopupMenuButton<String>(
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              value: 'edit',
              child: Text('Edit'),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: Text('Delete'),
            ),
            PopupMenuItem<String>(
              value: 'complete',
              child: Text('Mark as Completed'),
            ),
            PopupMenuItem<String>(
              value: 'changeRank',
              child: Text('Change Eisenhower Rank'),
            ),
          ],
          onSelected: (String value) {
            switch (value) {
              case 'edit':
                _showEditTaskBottomSheet(context, task);
                break;
              case 'delete':
                _deleteTask(task);
                break;
              case 'complete':
                _toggleTaskCompletion(task);
                break;
              case 'changeRank':
                _editEisenRank(task);
                break;
            }
          },
        ),
      );
    },
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

  Future<void> _toggleTaskCompletion(Task task) async {
    task.isCompleted = task.isCompleted == 1 ? 0 : 1;
    await TaskService().updateTask(task);
    _fetchTasks();
  }

  Future<void> _deleteTask(Task task) async {
    await TaskService().deleteTask(task.taskId);
    _fetchTasks();
  }

  Future<void> _editEisenRank(Task task) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return EditEisenhowerRankBottomSheet(task);
      },
    ).then((_) {
      // Refresh the task list after editing Eisenhower rank
      _fetchTasks();
    });
  }


  Future<void> _fetchTasks() async {
    List<Task> tasks = await TaskService().getTasks();
    setState(() {
      _tasks = tasks;
    });
    }
}
