import 'package:flutter/material.dart';

enum RepeatCycle {
  // noRepeat,
  onceADay,
  onceADayMonToFri,
  onceAWeek,
  onceAMonth,
  onceAYear,
  other,
}

enum Tenure {
  days,
  weeks,
  months,
  years,
}

class RepeatFreq {
  RepeatFreq({required this.num, required this.tenure});
  int num;
  Tenure tenure;
}

class Task {
  Task({
    required this.taskId,
    required this.taskListId,
    required this.taskName,
    required this.isFinished,
    required this.isRepeated,
    this.parentTaskId,
    this.deadlineDate,
    this.deadlineTime,
  }) {
    if (taskId == null) {
      this.taskId = counter;
      counter++;
    } else {
      this.taskId = taskId;
    }
  }
  static late int counter;

  // static initializeCounter(int counter) {
  //   Task.counter = counter;
  // }

  int taskId;
  int taskListId;
  int? parentTaskId; // used for repeated task instances only
  String taskName;
  DateTime? deadlineDate;
  TimeOfDay? deadlineTime;
  bool isFinished;
  bool isRepeated;
  void finishedTask() {
    isFinished = true;
  }
}

class RepeatedTask {
  RepeatedTask({
    required this.repeatedTaskId,
    required this.repeatingTaskName,
    required this.deadlineDate,
    required this.repeatCycle,
    this.repeatFreq,
    this.deadlineTime,
  });
  int repeatedTaskId;
  String repeatingTaskName;
  DateTime deadlineDate;
  RepeatCycle repeatCycle;
  DateTime? deadlineTime;
  RepeatFreq? repeatFreq;
}

class TaskList {
  TaskList({
    required this.taskListId,
    required this.taskListName,
    required this.nonRepeatingTasks,
    required this.repeatingTasks,
    required this.activeRepeatingTaskInstances,
  });
  int taskListId;
  String taskListName;
  List<Task> nonRepeatingTasks;
  List<RepeatedTask> repeatingTasks;
  List<Task> activeRepeatingTaskInstances;

  List<Task> getActiveTasks() {
    //TODO :: Select repeating task instances as well
    List<Task> activeNonRepeatingTasks = [];
    {
      for (var i = 0; i < nonRepeatingTasks.length; i++) {
        if (nonRepeatingTasks[i].isFinished == false) {
          activeNonRepeatingTasks.add(nonRepeatingTasks[i]);
        }
      }
      return (activeNonRepeatingTasks);
    }
  }

  // List<Task> getFinishedTasks() {
  //   // repeating instances as well as non-repeating instances
  // }

  void addTask({
    required String taskName,
    DateTime? deadlineDate,
    TimeOfDay? deadlineTime,
    int? parentTaskId,
  }) {
    var taskId;
    Task(
      taskId: taskId,
      taskName: taskName,
      isFinished: false,
      isRepeated: false,
      taskListId: taskListId,
      deadlineDate: deadlineDate,
      deadlineTime: deadlineTime,
      parentTaskId: parentTaskId,
    );

    if (parentTaskId != null) {}
  }
}
