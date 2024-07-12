import 'package:flutter/material.dart';
import 'package:task_management_app/models/task.dart';
import 'package:task_management_app/helpers/task_db_helper.dart';

class EditTaskBottomSheet extends StatefulWidget {
  final Task task;

  EditTaskBottomSheet(this.task);

  @override
  _EditTaskBottomSheetState createState() => _EditTaskBottomSheetState();
}

class _EditTaskBottomSheetState extends State<EditTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late String taskName;
  late DateTime dueDate;
  late String priority;
  late String description;

  @override
  void initState() {
    super.initState();
    taskName = widget.task.taskName;
    dueDate = DateTime.parse(widget.task.dueDate);
    priority = widget.task.priority;
    description = widget.task.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Task',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: taskName,
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
                    initialDate: dueDate,
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
                      Text('${dueDate.day}/${dueDate.month}/${dueDate.year}'),
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
                initialValue: description,
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
                        Task updatedTask = Task(
                          taskId: widget.task.taskId,
                          taskName: taskName,
                          dueDate: dueDate.toString(),
                          priority: priority,
                          description: description,
                          isCompleted: widget.task.isCompleted,
                        );
                        TaskService().updateTask(updatedTask);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Task updated successfully')),
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
    );
  }
}
