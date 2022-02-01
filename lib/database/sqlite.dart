import "package:path/path.dart";
import 'package:sqflite/sqflite.dart';
import 'package:todo/task.dart';

const String taskTable = "TASK";
const String listTable = "LIST";

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
            'CREATE TABLE $listTable (listId INTEGER PRIMARY KEY, listName TEXT, isActive INTEGER');

        await db.execute(
            'CREATE TABLE $taskTable (taskId INTEGER PRIMARY KEY, taskListId INTEGER, parentTaskId INTEGER, taskName TEXT, deadlineDate INTEGER, deadlineTime INTEGER, isFinished INTEGER, isRepeating INTEGER)');

        await db.insert(listTable, {"listName": "Default", "isActive": 1});
      },
    );
    _db = taskDb;
    return taskDb;
  }

  /// Count number of tables in DB
  static Future<int?> insertTask(Map<String, dynamic> taskData) async {
    var dbClient = await db;
    int id = await dbClient.insert(taskTable, taskData);
    if (id != 0) {
      return (id);
    } else {
      return (null);
    }
  }

  /// returns all tasks whose isFinished is false
  static Future<List<Task>> getAllPendingTasks() async {
    var dbClient = await db;
    //await Future.delayed(Duration(seconds: 1));
    List<Map<String, dynamic>> taskListFromDB = await dbClient.query(
      taskTable,
      where: "isFinished = ?",
      whereArgs: [0],
    );
    List<Task> taskListAsObjects = [];
    for (var map in taskListFromDB) {
      print(map);
      taskListAsObjects.add(Task.fromMap(map));
    }
    return (taskListAsObjects);
  }

  static Future<bool> updateTask(Task task) async {
    var dbClient = await db;
    int changes = await dbClient.update(
      taskTable,
      task.toMap(),
      where: "taskId = ?",
      whereArgs: [task.taskId],
    );
    print(changes);
    return (changes > 0);
  }

  static Future<bool> deleteTask(Task task) async {
    var dbClient = await db;
    int changes = await dbClient.delete(
      taskTable,
      where: "taskId = ?",
      whereArgs: [task.taskId],
    );
    return (changes == 1);
  }
}
