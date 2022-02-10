import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../datastore/sqlite.dart';
import 'package:todo/datastore/firestore_wrapper.dart';

class AggregatedTasks {
  // TaskList taskList;
  List<Task> overdue = [], thisMonth = [], later = [];
  // AggregatedTasks({required this.taskList});
}

enum Section {
  overdue,
  thisMonth,
  later,
}

class ToDoData extends ChangeNotifier {
  bool isDataLoaded = false;
  List<Task> activeTasks = [];

  List<TaskList> activeLists = [];

  Map<int, AggregatedTasks> aggregatedTasksMap = {};

  DateTime now = DateTime.now();
  DateTime today = DateTime.now();
  DateTime nextMonth = DateTime.now();
  String userId = "";

  int compareTasksByDeadline(Task a, Task b) {
    if (a.deadlineDate == null) return 1;

    if (b.deadlineDate == null) return -1;

    if (a.deadlineDate!.isAfter(b.deadlineDate!)) return 1;

    if (b.deadlineDate!.isAfter(a.deadlineDate!)) return -1;

    /// both a and b are on same dates
    if (a.deadlineTime == null) return 1;

    if (b.deadlineTime == null) return -1;

    if (intFromTimeOfDay(a.deadlineTime!) > intFromTimeOfDay(b.deadlineTime!)) {
      return 1;
    }
    if (intFromTimeOfDay(a.deadlineTime!) < intFromTimeOfDay(b.deadlineTime!)) {
      return -1;
    }
    return 0;
  }

  Section findSectionForTask(Task task) {
    if (task.deadlineDate == null) {
      return Section.later;
    } else if (task.deadlineDate!.isAfter(nextMonth)) {
      return Section.later;
    } else {
      DateTime exactDeadline = task.deadlineDate!;
      if (task.deadlineTime == null) {
        exactDeadline = DateTime(
            exactDeadline.year, exactDeadline.month, exactDeadline.day + 1);
      } else {
        exactDeadline = DateTime(
          exactDeadline.year,
          exactDeadline.month,
          exactDeadline.day,
          task.deadlineTime!.hour,
          task.deadlineTime!.minute,
        );
      }
      if (now.isAfter(exactDeadline)) {
        return Section.overdue;
      } else {
        return Section.thisMonth;
      }
    }
  }

  void init() async {
    userId = FirebaseAuth.instance.currentUser!.uid;

    now = DateTime.now();
    today = DateTime(now.year, now.month, now.day);
    nextMonth = DateTime(now.year, now.month, now.day + 30);

    activeLists = [
      TaskList(
        listId: defaultListId,
        listName: defaultListName,
        isActive: true,
      )
    ];

    activeTasks = (await FirestoreDB.getAllPendingTasks(userId))!;
    activeLists.addAll((await FirestoreDB.getAllActiveLists(userId))!);

    activeTasks.sort(compareTasksByDeadline);

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
      task.taskId = id.toString();
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
      listId: "-1",
      listName: listName,
    );
    var taskListAsMap = taskList.toMap();
    taskListAsMap.remove("listId");
    taskListAsMap["uid"] = userId;
    String? id = await FirestoreDB.insertList(taskListAsMap);
    if (id == null) {
      print("could not insert list into datastore");
    } else {
      taskList.listId = id;
      activeLists.add(taskList);
      notifyListeners();
    }
  }

  List<Task> fetchSection({
    required String selectedListId,
    required Section section,
  }) {
    List<Task> result = [];
    activeTasks.sort(compareTasksByDeadline);
    for (var task in activeTasks) {
      if (task.listId != selectedListId) {
        continue;
      }
      Section taskSection = findSectionForTask(task);
      if (taskSection == section) result.add(task);
    }
    return result;
  }
}
