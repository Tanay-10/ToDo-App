import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo/models/todo.dart';

final todoTable = "ToDo";

class NativeDatabaseService {
  NativeDatabaseService();

  static final NativeDatabaseService db = NativeDatabaseService();

  Database? _database;
  String? path;

  Future<Database> get database async {
    if (database != null) return _database!;
    _database = await myMethodToGetDb;
    return _database!;
  }

  Future<Database> get myMethodToGetDb async {
    String path = await getDatabasesPath();
    path = join(path, "todo.db");

    print("My sql file path $path");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) {
        db.execute(
          "CREATE TABLE  $todoTable (title TEXT, id PRIMARY INTEGER, category_id INTEGER, description TEXT, priority INTEGER, is_done INTEGER)",
        );
      },
    );
  }

  /// Create // Store new todo

  Future<int> createTodo(ToDoModel todo) async {
    print("Add new todo ${todo.title}");
    final db = await database;
    int result = await db.insert(todoTable, todo.toMap());
    print("Add new todo ${todo.title} ${result}");
    return result;
  }

  /// Update // Update existing todo

  Future<int> updateTodo(ToDoModel todo) async {
    final db = await database;
    int result =
        await db.update(todoTable, todo.toMap(), where: "id=${todo.id}");
    return result;
  }

  /// Delete // Delete todo

  Future<int> deleteTodo(ToDoModel todo) async {
    final db = await database;
    int result = await db.delete(todoTable, where: "id = ${todo.id}");
    return result;
  }

  /// Read // Read todo

  Future<List> getAllTodos(ToDoModel todo) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(todoTable);
    if (result == null || result.length == 0) return [];
    return result.map((e) => todo.fromMap(e)).toList();
  }

  Future<List> getAllIncompleteTodos(ToDoModel todo) async {
    final db = await database;
    List<Map<String, dynamic>> result =
        await db.query(todoTable, where: "is_done == 0");
    if (result == null || result.length == 0) return [];
    return result.map((e) => todo.fromMap(e)).toList();
  }

  Future<int> upsert(ToDoModel todo) async {
    final db = await database;

    var entries = await db.query(todoTable, where: "id = ${todo.id}");
    if (entries == 0)
      return await db.insert(
        todoTable,
        todo.toMap(),
      );
    return await db.update(todoTable, todo.toMap(), where: "id=${todo.id}");
  }
}
