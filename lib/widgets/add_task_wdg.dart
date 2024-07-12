import 'package:flutter/material.dart';
import 'package:task_management_app/models/task.dart';
import 'package:task_management_app/helpers/task_db_helper.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart'; 

class AddTaskBottomSheet extends StatefulWidget {
  @override
  _AddTaskBottomSheetState createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  String taskName = '';
  DateTime? dueDate;
  String priority = '';
  String description = '';

  final TaskService _taskService = TaskService();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Task',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Task Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter task name';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        taskName = newValue!;
                      },
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            dueDate = selectedDate;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Due Date',
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(dueDate != null
                                ? DateFormat('dd/MM/yyyy').format(dueDate!) 
                                : 'Select Date'),
                            Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Priority'),
                    RadioListTile<String>(
                      title: Text('High'),
                      value: 'High',
                      groupValue: priority,
                      onChanged: (value) {
                        setState(() {
                          priority = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Medium'),
                      value: 'Medium',
                      groupValue: priority,
                      onChanged: (value) {
                        setState(() {
                          priority = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Low'),
                      value: 'Low',
                      groupValue: priority,
                      onChanged: (value) {
                        setState(() {
                          priority = value!;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Description (Optional)'),
                      onSaved: (newValue) {
                        description = newValue!;
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              var uuid = Uuid();
                              Task newTask = Task(
                                taskId: uuid.v4(),
                                taskName: taskName,
                                dueDate: dueDate.toString(),
                                priority: priority,
                                description: description,
                              );
                              print('Due Date Format: ${newTask.dueDate.runtimeType}');
                              _taskService.addTask(newTask);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Task added successfully')),
                              );
                            }
                          },
                          child: Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
