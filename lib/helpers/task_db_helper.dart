import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:task_management_app/models/task.dart';
import 'package:task_management_app/helpers/db_helper.dart';

class TaskService {
  final TaskDatabaseHelper _databaseHelper = TaskDatabaseHelper();
  final String db_name = 'final_tasks';

  Future<void> addTask(Task task) async {
    final Database db = await _databaseHelper.database;
    await db.insert(
      db_name,
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("task added!");
  }

  Future<void> updateTask(Task task) async {
    final Database db = await _databaseHelper.database;
    await db.update(
      db_name,
      task.toJson(),
      where: 'taskId = ?',
      whereArgs: [task.taskId],
    );
  }

  Future<void> deleteTask(String taskId) async {
    final Database db = await _databaseHelper.database;
    await db.delete(
      db_name, 
      where: 'taskId = ?',
      whereArgs: [taskId],
    );
  }

  Future<List<Task>> getTasks() async {
    final Database db = await _databaseHelper.database;
    final List<Map<String, dynamic>> taskMaps = await db.query(db_name);
    return List.generate(taskMaps.length, (i) {
      return Task(
        taskId: taskMaps[i]['taskId'],
        taskName: taskMaps[i]['taskName'],
        dueDate: taskMaps[i]['dueDate'],
        priority: taskMaps[i]['priority'],
        description: taskMaps[i]['description'],
        eisenhowerMatrixRank: taskMaps[i]['eisenhowerMatrixRank'],
        isCompleted: taskMaps[i]['isCompleted'],
      );
    });
  }
}
