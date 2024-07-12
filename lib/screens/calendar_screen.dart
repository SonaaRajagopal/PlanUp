import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_management_app/models/task.dart';
import 'package:task_management_app/helpers/task_db_helper.dart';
import 'package:task_management_app/widgets/edit_task_wdg.dart';

class CalendarGrid extends StatefulWidget {
  @override
  _CalendarGridState createState() => _CalendarGridState();
}

class _CalendarGridState extends State<CalendarGrid> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  List<Task> _tasksForSelectedDay = [];

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _fetchTasksForSelectedDay(_selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    print('Selected Day Format: ${_selectedDay.runtimeType}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar Grid',
        style:TextStyle(
        color: Color.fromARGB(255, 1, 25, 131),
        fontWeight:FontWeight.w900,
        fontSize: 29,
        ),
      ),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _fetchTasksForSelectedDay(selectedDay);
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
          ),
          SizedBox(height: 20),
          Text(
            'Tasks on ${DateFormat('dd/MM/yyyy').format(_selectedDay)} :',
            style: TextStyle(fontWeight: FontWeight.bold,fontSize:19.0),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasksForSelectedDay.length,
              itemBuilder: (context, index) {
                Task task = _tasksForSelectedDay[index];
                return ListTile(
                  title: Text(
                    task.taskName,
                    style: TextStyle(
                      decoration: task.isCompleted == 1 ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(task.description ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _navigateToEditTaskScreen(task);
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
                          task.isCompleted == 1 ? Icons.check_box : Icons.check_box_outline_blank,
                          color: task.isCompleted == 1 ? Colors.green : null,
                        ),
                        onPressed: () {
                          _toggleTaskCompletion(task);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchTasksForSelectedDay(DateTime selectedDay) async {
    List<Task> tasks = await TaskService().getTasks();
    setState(() {
      _tasksForSelectedDay = tasks.where((task) {
        DateTime dueDate = DateTime.parse(task.dueDate);
        return isSameDay(dueDate, selectedDay);
      }).toList();
      _tasksForSelectedDay.sort((a, b) => a.taskName.compareTo(b.taskName));
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
      _fetchTasksForSelectedDay(_selectedDay);
    });
  }

  Future<void> _deleteTask(Task task) async {
    await TaskService().deleteTask(task.taskId);
    _fetchTasksForSelectedDay(_selectedDay);
  }

  Future<void> _toggleTaskCompletion(Task task) async {
    task.isCompleted = task.isCompleted == 1 ? 0 : 1;
    await TaskService().updateTask(task);
    _fetchTasksForSelectedDay(_selectedDay);
  }
}
