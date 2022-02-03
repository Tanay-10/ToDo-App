import 'package:flutter/material.dart';

//used to display in UI
const String noRepeat = "No Repeat";
const String defaultListName = "Default";
const int defaultListId = 1;

enum RepeatCycle {
  onceADay,
  onceADayMonFri,
  onceAWeek,
  onceAMonth,
  onceAYear,
  other,
}

String repeatCycleToUIString(RepeatCycle r) {
  Map<RepeatCycle, String> mapper = {
    RepeatCycle.onceADay: "Once A Day",
    RepeatCycle.onceADayMonFri: "Once A Day( Mon-Fri )",
    RepeatCycle.onceAWeek: "Once A Week",
    RepeatCycle.onceAMonth: "Once A Month",
    RepeatCycle.onceAYear: "Once A Year",
    RepeatCycle.other: "Other...",
  };
  return (mapper[r]!);
}

enum Tenure { days, weeks, months, years }

class RepeatFreq {
  RepeatFreq({required this.num, required this.tenure});
  int num;
  Tenure tenure;
}

class Task {
  Task({
    required this.taskName,
    required this.listId,
    required this.taskId,
    required this.isFinished,
    required this.isRepeating,
    this.parentTaskId,
    this.deadlineDate,
    this.deadlineTime,
  });

  int taskId;
  int listId;
  int? parentTaskId; //used for repeated task instances only
  String taskName;
  DateTime? deadlineDate;
  TimeOfDay? deadlineTime;
  bool isFinished;
  bool isRepeating;
  void finishTask() {
    isFinished = true;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> taskAsMap = {
      "taskId": taskId,
      "listId": listId,
      "parentTaskId": null,
      "taskName": taskName,
      "deadlineDate":
          deadlineDate == null ? null : deadlineDate!.millisecondsSinceEpoch,
      "deadlineTime":
          deadlineTime == null ? null : intFromTimeOfDay(deadlineTime!),
      "isFinished": isFinished == true ? 1 : 0,
      "isRepeating": isRepeating == true ? 1 : 0,
    };
    return (taskAsMap);
  }

  static Task fromMap(Map<String, dynamic> taskAsMap) {
    Task task = Task(
      taskId: taskAsMap["taskId"],
      listId: taskAsMap["listId"],
      parentTaskId: taskAsMap["parentTaskId"],
      taskName: taskAsMap["taskName"],
      deadlineDate: taskAsMap["deadlineDate"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(taskAsMap["deadlineDate"]),
      deadlineTime: taskAsMap["deadlineTime"] == null
          ? null
          : timeOfDayFromInt(taskAsMap["deadlineTime"]),
      isFinished: taskAsMap["isFinished"] == 0 ? false : true,
      isRepeating: taskAsMap["isRepeating"] == 0 ? false : true,
    );
    return (task);
  }
}

int intFromTimeOfDay(TimeOfDay tod) {
  return (tod.minute + 60 * tod.hour);
}

TimeOfDay timeOfDayFromInt(int todInt) {
  return TimeOfDay(hour: todInt ~/ 60, minute: todInt % 60);
}

class RepeatingTask {
  RepeatingTask({
    required this.repeatingTaskId,
    required this.repeatingTaskName,
    required this.repeatCycle,
    required this.deadlineDate,
    this.repeatFrequency,
    this.deadlineTime,
    required this.taskListId,
  });
  int taskListId;
  int repeatingTaskId;
  String repeatingTaskName;
  RepeatCycle repeatCycle;
  RepeatFreq? repeatFrequency;
  DateTime deadlineDate;
  DateTime? deadlineTime;
}

class TaskList {
  int listId;
  String listName;
  bool isActive;
  // List<Task> nonRepeatingTasks;
  // List<RepeatingTask> repeatingTasks;
  // List<Task> activeRepeatingTaskInstances;
  TaskList({
    required this.listId,
    required this.listName,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return {
      "listId": listId,
      "listName": listName,
      "isActive": isActive ? 1 : 0,
    };
  }

  static TaskList fromMap(Map<String, dynamic> taskListAsMap) {
    return (TaskList(
      isActive: taskListAsMap["isActive"] == 1 ? true : false,
      listId: taskListAsMap["listId"],
      listName: taskListAsMap["listName"],
    ));
  }

/*List<Task> getActiveTasks() {
    //TODO::Select repeating Task Instances as well
    List<Task> activeNonRepeatingTasks = [];
    {
      for (var i = 0; i < nonRepeatingTasks.length; i++) {
        if (nonRepeatingTasks[i].finished == false) {
          activeNonRepeatingTasks.add(nonRepeatingTasks[i]);
        }
      }
      return (activeNonRepeatingTasks);
    }
  }*/

/*List<Task> getFinishedTasks() {
    //repeating Instances as well as non-repeating Instances
    return ([]);
  }

  void FinishTask(Task task) {}*/

}
