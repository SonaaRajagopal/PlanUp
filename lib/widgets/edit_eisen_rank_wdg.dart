import 'package:flutter/material.dart';
import 'package:task_management_app/models/task.dart';
import 'package:task_management_app/helpers/task_db_helper.dart';

class EditEisenhowerRankBottomSheet extends StatefulWidget {
  final Task task;

  EditEisenhowerRankBottomSheet(this.task);

  @override
  _EditEisenhowerRankBottomSheetState createState() => _EditEisenhowerRankBottomSheetState();
}

class _EditEisenhowerRankBottomSheetState extends State<EditEisenhowerRankBottomSheet> {
  int? _selectedRank;

  @override
  void initState() {
    super.initState();
    _selectedRank = widget.task.eisenhowerMatrixRank;
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Eisenhower Rank',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            RadioListTile<int>(
              title: Text('Urgent & Important'),
              value: 1,
              groupValue: _selectedRank,
              onChanged: (value) {
                setState(() {
                  _selectedRank = value;
                });
              },
            ),
            RadioListTile<int>(
              title: Text('Important, Not Urgent'),
              value: 2,
              groupValue: _selectedRank,
              onChanged: (value) {
                setState(() {
                  _selectedRank = value;
                });
              },
            ),
            RadioListTile<int>(
              title: Text('Urgent, Not Important'),
              value: 3,
              groupValue: _selectedRank,
              onChanged: (value) {
                setState(() {
                  _selectedRank = value;
                });
              },
            ),
            RadioListTile<int>(
              title: Text('Not Urgent & Not Important'),
              value: 4,
              groupValue: _selectedRank,
              onChanged: (value) {
                setState(() {
                  _selectedRank = value;
                });
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
                    if (_selectedRank != null) {
                      Task updatedTask = Task(
                        taskId: widget.task.taskId,
                        taskName: widget.task.taskName,
                        dueDate: widget.task.dueDate,
                        priority: widget.task.priority,
                        description: widget.task.description,
                        isCompleted: widget.task.isCompleted,
                        eisenhowerMatrixRank: _selectedRank!,
                      );
                      TaskService().updateTask(updatedTask);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Eisenhower Rank updated successfully')),
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
    );
  }
}
