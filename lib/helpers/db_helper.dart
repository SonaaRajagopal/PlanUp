import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class TaskDatabaseHelper {
  static final TaskDatabaseHelper _instance = TaskDatabaseHelper._internal();
  factory TaskDatabaseHelper() => _instance;
  TaskDatabaseHelper._internal();
  static Database? _database;
  // ignore: non_constant_identifier_names
  final String db_name = 'final_tasks';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'final_tasks.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS final_tasks(
        taskId CHAR PRIMARY KEY,
        taskName TEXT NOT NULL,
        dueDate TEXT NOT NULL,
        priority TEXT NOT NULL,
        description TEXT,
        eisenhowerMatrixRank INTEGER,
        isCompleted INTEGER NOT NULL
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    Database db = await database;
    return await db.query(db_name);
  }

  /*
  Future<void> addTask(Map<String, dynamic> task) async {
    Database db = await database;
    await db.insert(db_name, task);
  }

  Future<void> updateTask(String taskId, Map<String, dynamic> task) async {
    Database db = await database;
    await db.update(db_name, task, where: 'taskId = ?', whereArgs: [taskId]);
  }

  Future<void> deleteTask(String taskId) async {
    Database db = await database;
    await db.delete(db_name, where: 'taskId = ?', whereArgs: [taskId]);
  }

    Future<void> markTaskCompleted(String taskId) async {
    Database db = await database;
    await db.update(
      db_name,
      {'isCompleted': 1},
      where: 'taskId = ?',
      whereArgs: [taskId],
    );
  }*/
  
}
