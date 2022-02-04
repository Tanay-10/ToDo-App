import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo/task.dart';
import '../database/sqlite.dart';

class AggregatedTasks {
  TaskList taskList;
  List<Task> overdue = [],
      today = [],
      thisWeek = [],
      thisMonth = [],
      noDeadLine = [];
  AggregatedTasks({required this.taskList});
}

class ToDoData extends ChangeNotifier {
  bool isDataLoaded = false;
  List<Task> activeTasks = [];

  ToDoData() {
    init();
  }

  List<TaskList> activeLists = [];

  Map<int, AggregatedTasks> aggregatedTasksArray = {};

  void init() async {
    activeTasks = await SqliteDB.getAllPendingTasks();
    activeLists = await SqliteDB.getAllActiveLists();
    for (var taskList in activeLists) {
      aggregatedTasksArray[taskList.listId] =
          AggregatedTasks(taskList: taskList);
    }
    activeTasks.sort();
    isDataLoaded = true;
    notifyListeners();
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

  void addList(String listName) async {
    TaskList taskList = TaskList(
      isActive: true,
      listId: -1,
      listName: listName,
    );
    var taskListAsMap = taskList.toMap();
    taskListAsMap.remove("listId");
    int? id = await SqliteDB.insertList(taskListAsMap);
    if (id == null) {
      print("could not insert list into database");
    } else {
      taskList.listId = id;
      activeLists.add(taskList);
      notifyListeners();
    }
  }
}
