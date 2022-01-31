import "package:path/path.dart";
import 'package:sqflite/sqflite.dart';
import 'package:todo/task.dart';

class SqliteDB {
  SqliteDB.internal();
  static Database? _db;
  static Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  /// Initialize DB
  static initDb() async {
    String folderPath = await getDatabasesPath();
    String path = join(folderPath, "todo.db");
    // await deleteDatabase(path);
    var taskDb = await openDatabase(
      path,
      version: 3,
      onCreate: (Database db, int t) async {
        await db.execute(
            'CREATE TABLE TASK (taskID INTEGER PRIMARY KEY, taskListID INTEGER, parentTaskID INTEGER, taskName TEXT, deadlineDate INTEGER, deadlineTime INTEGER, isFinished INTEGER, isRepeating INTEGER)');
      },
    );
    _db = taskDb;
    return taskDb;
  }

  /// Count number of tables in DB
  static Future<int?> insertTask(Map<String, dynamic> taskData) async {
    var dbClient = await db;
    int id = await dbClient.insert("TASK", taskData);
    if (id != 0) {
      return (id);
    } else {
      return (null);
    }
  }

  static Future<List<Task>> getAllTasks() async {
    var dbClient = await db;
    //await Future.delayed(Duration(seconds: 1));
    List<Map<String, dynamic>> taskListFromDB = await dbClient.query("TASK");
    List<Task> taskListAsObjects = [];
    for (var map in taskListFromDB) {
      taskListAsObjects.add(Task.fromMap(map));
    }
    return (taskListAsObjects);
  }
}
