import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo/task.dart';

final taskTable = "TASK";

class SqliteDB {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  /// Initialize DB
  static initDb() async {
    String folderPath = await getDatabasesPath();
    String path = join(folderPath, "todo.db");
    var taskDb = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) {
        db.execute(
            'CREATE TABLE $taskTable (id INTEGER PRIMARY KEY, taskListID INTEGER, parentTaskID INTEGER, taskName TEXT, deadlineDate INTEGER, deadlineTime INTEGER, isFinished INTEGER, isRepeating INTEGER)');
      },
    );
    _db = taskDb;
    return taskDb;
  }

  /// Count number of tables in DB
  static Future<int?> insertTask(Map<String, dynamic> taskData) async {
    var dbClient = await db;
    int id = await dbClient.insert(taskTable, taskData);
    if (id != 0)
      return id;
    else
      return null;
  }

  // static Future<List<Task>> getAllTasks() async{
  //   var dbClient = await db;
  //   List<Map<String, dynamic>> taskListFromDB = await dbClient.query(taskTable);
  //   for (var map)
  // }
}
