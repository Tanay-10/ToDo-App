import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo/task.dart';
import 'database/sqlite.dart';

class SharedData extends ChangeNotifier {
  int x = 1, y = 2;
  SharedData();

  incrementX() {
    x = x + 1;
    notifyListeners();
  }
}

class ToDoData extends ChangeNotifier {
  bool isDataLoaded = false;
  List<Task> activeTaskList = [];
  ToDoData() {
    init();
  }
  void init() async {
    activeTaskList = await SqliteDB.getAllPendingTasks();
    isDataLoaded = true;
    notifyListeners();
  }

  void addTask(Task task) async {
    var taskAsMap = task.toMap();
    taskAsMap.remove("taskId");
    int? id = await SqliteDB.insertTask(taskAsMap);
    if (id == null) {
      print("could not insert");
    } else {
      task.taskId = id;
      activeTaskList.add(task);
      notifyListeners();
    }
  }
}
