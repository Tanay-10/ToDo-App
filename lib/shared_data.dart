import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo/task.dart';
import 'database/sqlite.dart';

class ToDoData extends ChangeNotifier {
  bool isDataLoaded = false;
  List<Task> activeTasks = [];

  ToDoData() {
    init();
  }

  List<TaskList> activeLists = [];

  void init() async {
    activeTasks = await SqliteDB.getAllPendingTasks();
    activeLists = await SqliteDB.getAllActiveLists();
    isDataLoaded = true;
    notifyListeners();
  }

  void addTask(Task task) async {
    print("I am add task");
    var taskAsMap = task.toMap();
    taskAsMap.remove("taskId");
    int? id = await SqliteDB.insertTask(taskAsMap);
    if (id == null) {
      print("could not insert");
    } else {
      task.taskId = id;
      activeTasks.add(task);
      notifyListeners();
    }
  }

  void updateTask(Task task) async {
    print("I am update task");
    bool success = await SqliteDB.updateTask(task);
    if (success == false) {
      print("could not update");
    }
    {
      var index = findTaskIndex(task);
      if (index != null) {
        activeTasks[index] = task;
      } else {
        print("task not found");
      }
    }
    notifyListeners();
  }

  void deleteTask(Task task) async {
    bool success = await SqliteDB.deleteTask(task);
    if (success == false) {
      print("could not delete task");
    } else {
      var index = findTaskIndex(task);
      if (index != null) {
        activeTasks.removeAt(index);
        notifyListeners();
        print("Task with id ${activeTasks[index].taskId} deleted");
      } else {
        print("task not found");
      }
    }
  }

  void finishTask(Task task) async {
    task.isFinished = true;
    SqliteDB.updateTask(task);
    var index = findTaskIndex(task);
    if (index == null) {
      print("Task not found");
    } else {
      activeTasks.removeAt(index);
      notifyListeners();
    }
  }

  int? findTaskIndex(Task task) {
    var index = activeTasks.indexWhere((Task t) {
      return t.taskId == task.taskId;
    });
    if (index == -1) {
      return null;
    }
    return index;
  }
}
