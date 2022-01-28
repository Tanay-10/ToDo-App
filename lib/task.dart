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
  static late int counter;
  Task({
    required this.taskListId,
    required this.taskName,
    required this.finished,
    taskId = null,
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

  static initializeCounter(int counter) {
    Task.counter = counter;
  }

  late int taskId;
  int taskListId;
  int? parentTaskId; // used for repeated task instances only
  String taskName;
  DateTime? deadlineDate;
  DateTime? deadlineTime;
  bool finished;
  void finishedTask() {
    finished = true;
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
        if (nonRepeatingTasks[i].finished == false) {
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
    DateTime? deadlineTime,
    int? parentTaskId,
  }) {
    Task(
      taskName: taskName,
      finished: false,
      taskListId: taskListId,
      deadlineDate: deadlineDate,
      deadlineTime: deadlineTime,
      parentTaskId: parentTaskId,
    );

    if (parentTaskId != null) {}
  }
}
