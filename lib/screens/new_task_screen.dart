import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/task.dart';
import 'routing.dart' as routing;
import '../database/sqlite.dart';

class NewTaskScreen extends StatefulWidget {
  NewTaskScreen({Key? key, this.task}) : super(key: key);
  final Task? task;
  @override
  _NewTaskScreenState createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  Task task = Task(
      isFinished: false,
      isRepeating: false,
      taskName: "",
      taskListId: 0,
      taskId: -1,
      parentTaskId: null,
      deadlineDate: null,
      deadlineTime: null);
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  RepeatCycle? chosenRepeatCycle;
  RepeatFreq repeatFrequency = RepeatFreq(num: 2, tenure: Tenure.days);

  void datePicker() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate:
            task.deadlineDate == null ? DateTime.now() : task.deadlineDate!,
        firstDate: DateTime.now(),
        //TODO::lastDate should be 50/100/x number of years from now
        lastDate: DateTime(2101));
    if (pickedDate != null) {
      task.deadlineDate = pickedDate;
      setState(() {});
      var dateString = DateFormat('EEEE, d MMM, yyyy').format(pickedDate);
      dateController.text = dateString;
    }
  }

  void timePicker() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      task.deadlineTime = pickedTime;
      setState(() {});
      timeController.text = pickedTime.format(context);
    }
  }

  List<DropdownMenuItem<String>> dropdownItemCreator(List<String> itemValues) {
    List<DropdownMenuItem<String>> dropdownMenuItems = [];
    for (var i = 0; i < itemValues.length; i++) {
      dropdownMenuItems.add(
        DropdownMenuItem<String>(
          value: itemValues[i],
          child: Text(itemValues[i]),
        ),
      );
    }
    return dropdownMenuItems;
  }

  void saveNewTask() async {
    Map<String, dynamic> taskAsMap = task.toMap();
    taskAsMap.remove("taskId");
    int? taskId = await SqliteDB.insertTask(taskAsMap);
    if (taskId == null) {
    } else {
      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(
          context, routing.homeScreenId, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.task);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.check,
          size: 35,
        ),
        onPressed: () {
          saveNewTask();
        },
      ),
      appBar: AppBar(
        title: Text("New Task"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Task details
            const Text(
              "What is to be done?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 10),
                Flexible(
                  child: TextField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      isDense: true,
                      hintText: "Enter Task Here",
                    ),
                    onChanged: (String? value) {
                      task.taskName = value == null ? task.taskName : value;
                    },
                  ),
                ),
                CustomIconButton(iconData: Icons.mic, onPressed: () {}),
              ],
            ),
            const SizedBox(
              height: 50,
            ),

            //Date Time Input
            const Text(
              "Due Date",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            EditableFieldWithCancelButton(
              hintText: "Date not set",
              iconData: Icons.calendar_today_outlined,
              textController: dateController,
              picker: datePicker,
              onCancel: () {
                task.deadlineDate = null;
                dateController.text = "";
                task.deadlineTime = null;
                timeController.text = "";
                setState(() {});
              },
              enableCancelButton: () {
                return (task.deadlineDate != null);
              },
            ),

            //Time Input
            const SizedBox(height: 10),
            Visibility(
              visible: task.deadlineDate != null ? true : false,
              child: EditableFieldWithCancelButton(
                hintText: "Time not set",
                iconData: Icons.access_time,
                textController: timeController,
                picker: timePicker,
                onCancel: () {
                  task.deadlineTime = null;
                  setState(() {});
                  timeController.text = "";
                },
                enableCancelButton: () {
                  return (task.deadlineTime != null);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Notifications",
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.deadlineDate != null
                        ? "Day summary on the same day at 8:00 am."
                        : "No notifications if date not set",
                  ),
                  const SizedBox(height: 4),
                  Visibility(
                    child: const Text(
                      "Individual notification on time",
                    ),
                    visible: task.deadlineTime != null,
                  ),
                ],
              ),
            ),

            //Repeating Info
            const SizedBox(height: 40),
            const Text(
              "Repeat",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 10),
                DropdownButton<dynamic>(
                  items: () {
                    List<DropdownMenuItem<dynamic>> items = [];
                    items.add(const DropdownMenuItem<dynamic>(
                      child: Text(
                        noRepeat,
                      ),
                      value: noRepeat,
                    ));
                    for (var value in RepeatCycle.values) {
                      items.add(DropdownMenuItem<dynamic>(
                        child: Text(
                          repeatCycleToUIString(value),
                        ),
                        value: value,
                      ));
                    }

                    //values.add(noRepeat);
                    return (items);
                  }(),
                  value: chosenRepeatCycle ?? noRepeat,
                  onChanged: (dynamic chosenValue) {
                    if (chosenValue != null) {
                      if (chosenValue == noRepeat)
                        chosenRepeatCycle = null;
                      else
                        chosenRepeatCycle = chosenValue;
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
            Visibility(
              visible: chosenRepeatCycle == RepeatCycle.other,
              child: Column(children: [
                const SizedBox(height: 10),
                Row(children: [
                  const SizedBox(width: 10),
                  DropdownButton<int>(
                    items: [2, 3, 4, 5, 6, 7, 8, 9, 10]
                        .map((int t) => DropdownMenuItem<int>(
                              child: Text(t.toString()),
                              value: t,
                            ))
                        .toList(),
                    value: repeatFrequency.num,
                    onChanged: (value) {
                      if (value != null) {
                        repeatFrequency.num = value;
                        setState(() {});
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<Tenure>(
                    items: Tenure.values
                        .map((Tenure t) => DropdownMenuItem<Tenure>(
                              child: Text(describeEnum(t)),
                              value: t,
                            ))
                        .toList(),
                    value: repeatFrequency.tenure,
                    onChanged: (value) {
                      if (value != null) {
                        repeatFrequency.tenure = value;
                        setState(() {});
                      }
                    },
                  )
                ])
              ]),
            ),

            const SizedBox(height: 40),
            const Text(
              "Select a List",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const SizedBox(width: 10),
                DropdownButton<String>(
                  items: dropdownItemCreator(["Default"]),
                  value: "Default",
                  onChanged: (value) {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditableFieldWithCancelButton extends StatelessWidget {
  const EditableFieldWithCancelButton({
    Key? key,
    required this.hintText,
    required this.iconData,
    required this.textController,
    required this.picker,
    required this.onCancel,
    required this.enableCancelButton,
  }) : super(key: key);

  final String hintText;
  final IconData iconData;
  final TextEditingController textController;
  final void Function() picker;
  final void Function() onCancel;
  final bool Function() enableCancelButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 5),
        Flexible(
          child: TextField(
            controller: textController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
              isDense: true,
              hintText: hintText,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white60,
                ),
              ),
            ),
            onTap: picker,
            enableInteractiveSelection: false,
            showCursor: false,
            readOnly: true,
          ),
        ),
        const SizedBox(width: 5),
        CustomIconButton(
          iconData: iconData,
          onPressed: picker,
        ),
        Visibility(
            child: CustomIconButton(
              iconData: Icons.cancel_rounded,
              onPressed: onCancel,
            ),
            visible: enableCancelButton()),
      ],
    );
  }
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    required this.iconData,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final IconData iconData;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
      ),
      child: Icon(iconData),
      onPressed: onPressed,
    );
  }
}

/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/task.dart';
import 'routing.dart' as routing;
import '../database/sqlite.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({Key? key, this.task}) : super(key: key);
  final Task? task;

  @override
  _NewTaskScreenState createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  Task task = Task(
    taskId: -1,
    taskListId: 0,
    taskName: "",
    isFinished: false,
    isRepeating: false,
    parentTaskId: null,
    deadlineDate: null,
    deadlineTime: null,
  );

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  RepeatCycle? chosenRepeatCycle;
  RepeatFreq repeatFreq = RepeatFreq(num: 2, tenure: Tenure.days);

  List<String> dropdownOptions = [
    "No Repeat",
    "Once a Day",
    "Once a Day [Mon-Fri]",
    "Once a Week",
    "Once a Month",
    "Once a Year",
    "Other",
  ];

  String selectedFrequency = "No Repeat";

  List<DropdownMenuItem<String>> dropdownItemCreator(List<String> itemValues) {
    List<DropdownMenuItem<String>> dropdownMenuItems = [];
    for (var i = 0; i < itemValues.length; i++) {
      dropdownMenuItems.add(
        DropdownMenuItem<String>(
          value: itemValues[i],
          child: Text(itemValues[i]),
        ),
      );
    }
    return dropdownMenuItems;
  }

  List<String> listOptions = ["Default"];
  String defaultOption = "Default";

  List<DropdownMenuItem<String>> dropdownListCreator(List<String> listValues) {
    List<DropdownMenuItem<String>> dropdownLists = [];
    for (var i = 0; i < listValues.length; i++) {
      dropdownLists.add(
        DropdownMenuItem<String>(
          value: listValues[i],
          child: Text(listValues[i]),
        ),
      );
    }
    return dropdownLists;
  }

  void openDatePicker() async {
    print("opened the calender");
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
          task.deadlineDate == null ? DateTime.now() : task.deadlineDate!,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      task.deadlineDate = pickedDate;
      setState(() {});
      var dateString = DateFormat('EEEE, d MMM, yyyy').format(pickedDate);
      dateController.text = dateString;
    }
  }

  void openTimePicker() async {
    print("opened the clock");
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime:
          task.deadlineTime == null ? TimeOfDay.now() : task.deadlineTime!,
    );
    if (pickedTime != null) {
      task.deadlineTime = pickedTime;
      setState(() {});
      var timeString = pickedTime.format(context);
      timeController.text = timeString;
    }
  }

  final repeatSpan = [
    "Days",
    "Weeks",
    "Months",
    "Years",
  ];

  TextEditingController listController = TextEditingController();

  void createDialog() {
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Create new list",
        style: TextStyle(fontSize: 17),
      ),
      content: Flexible(
        child: TextField(
          controller: listController,
          decoration: const InputDecoration(
            hintText: "Enter Text Here",
          ),
          textAlignVertical: TextAlignVertical.bottom,
          autofocus: false,
        ),
      ),
      actions: [
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text("Create"),
          onPressed: () {
            if (listController.text != " ") {
              listOptions.add(listController.text);
            }
            Navigator.pop(context);
            setState(() {});
          },
        ),
      ],
      elevation: 100.0,
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  void saveNewTask() async {
    Map<String, dynamic> taskAsMap = task.toMap();
    taskAsMap.remove("taskId");
    int? taskId = await SqliteDB.insertTask(taskAsMap);
    if (taskId == null) {
      print("failed");
    } else {
      print("success");
      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(
          context, routing.homeScreenId, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final taskState
    print(widget.task);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: CupertinoColors.systemBlue,
        child: const Icon(
          Icons.check,
          size: 40,
        ),
        onPressed: () {
          saveNewTask();
        },
      ),
      appBar: AppBar(
        title: const Text(
          "New Task",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "What is to be done?",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    onChanged: (String? value) {
                      task.taskName = value == null ? task.taskName : value;
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      hintText: "Enter Task Here",
                      isDense: true,
                    ),
                    textAlignVertical: TextAlignVertical.bottom,
                    autofocus: false,
                  ),
                ),
                CustomIconButton(
                  iconData: Icons.mic_sharp,
                  onPressed: () {
                    print("mic active");
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Due Date",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Row(
            //   children: [
            //     Flexible(
            //       child: TextField(
            //         onTap: openDatePicker,
            //         readOnly: true,
            //         controller: dateController,
            //         decoration: const InputDecoration(
            //           contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 5),
            //           hintText: "Select the due date",
            //           isDense: true,
            //         ),
            //         // textDirection: TextDirection.ltr,
            //         textAlignVertical: TextAlignVertical.bottom,
            //         autofocus: false,
            //       ),
            //     ),
            //     CustomIconButton(
            //       iconData: Icons.calendar_today_sharp,
            //       onPressed: openDatePicker,
            //     ),
            //     Visibility(
            //       visible: date == null ? false : true,
            //       child: CustomIconButton(
            //         iconData: Icons.cancel_rounded,
            //         onPressed: () {
            //           print("selected date removed");
            //           date = null;
            //           setState(() {});
            //           dateController.text = "";
            //         },
            //       ),
            //     ),
            //   ],
            // ),
            EditableFieldWithCancelButton(
              hintText: "Select a date",
              iconData: Icons.calendar_today_sharp,
              textController: dateController,
              picker: openDatePicker,
              onCancel: () {
                task.deadlineDate = null;
                dateController.text = "";
                task.deadlineTime = null;
                timeController.text = "";
                setState(() {});
              },
              enableCancelButton: () {
                return (task.deadlineDate != null);
              },
            ),
            const SizedBox(
              height: 13,
            ),
            Visibility(
              visible: task.deadlineDate == null ? false : true,
              // child: Row(
              //   children: [
              //     Flexible(
              //       child: TextField(
              //         onTap: openTimePicker,
              //         readOnly: true,
              //         controller: timeController,
              //         decoration: const InputDecoration(
              //           contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 5),
              //           hintText: "Set time",
              //           isDense: true,
              //         ),
              //         // textDirection: TextDirection.ltr,
              //         textAlignVertical: TextAlignVertical.bottom,
              //         autofocus: false,
              //       ),
              //     ),
              //     CustomIconButton(
              //       iconData: Icons.watch_later_outlined,
              //       onPressed: openTimePicker,
              //     ),
              //     Visibility(
              //       visible: time == null ? false : true,
              //       child: CustomIconButton(
              //         iconData: Icons.cancel_rounded,
              //         onPressed: () {
              //           print("selected time removed");
              //           time = null;
              //           setState(() {});
              //           timeController.text = "";
              //         },
              //       ),
              //     ),
              //   ],
              // ),
              child: EditableFieldWithCancelButton(
                  hintText: "Select time",
                  iconData: Icons.watch_later_outlined,
                  textController: timeController,
                  picker: openTimePicker,
                  onCancel: () {
                    task.deadlineTime = null;
                    setState(() {});
                    timeController.text = "";
                  },
                  enableCancelButton: () {
                    return (task.deadlineTime != null);
                  }),
            ),
            const SizedBox(
              height: 80,
            ),
            const Text("Repeat"),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                DropdownButton<dynamic>(
                    items: () {
                      List<DropdownMenuItem<dynamic>> items = [];
                      items.add(
                        const DropdownMenuItem<dynamic>(
                            child: Text(
                              noRepeat,
                            ),
                            value: noRepeat),
                      );
                      for (var value in RepeatCycle.values) {
                        items.add(
                          DropdownMenuItem<dynamic>(
                            child: Text(
                              repeatCycleToUIString(value),
                            ),
                            value: value,
                          ),
                        );
                      }
                      return (items);
                    }(),
                    value: chosenRepeatCycle ?? noRepeat,
                    onChanged: (dynamic chosenValue) {
                      if (chosenValue != null) {
                        if (chosenValue != noRepeat) {
                          chosenRepeatCycle = null;
                        } else {
                          chosenRepeatCycle = chosenValue;
                        }
                        setState(() {});
                      }
                      // else {
                      //   AlertDialog alert = AlertDialog(
                      //     title: Text(
                      //       "Repeat",
                      //       style: TextStyle(fontSize: 17),
                      //     ),
                      //     actions: [
                      //       TextButton(
                      //         onPressed: () {
                      //           Navigator.pop(context);
                      //         },
                      //         child: Text("Cancel"),
                      //       ),
                      //       TextButton(
                      //         onPressed: () {},
                      //         child: Text("Set"),
                      //       )
                      //     ],
                      //     content: CupertinoPicker(
                      //       magnification: 1.2,
                      //       children: repeatSpan
                      //           .map((item) => Center(
                      //                 child: Text(item),
                      //               ))
                      //           .toList(),
                      //       onSelectedItemChanged: (index) {
                      //         print(index);
                      //       },
                      //       itemExtent: 60.0,
                      //     ),
                      //     elevation: 100.0,
                      //   );
                      //   showDialog(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return alert;
                      //     },
                      //     // barrierDismissible: false,
                      //   );
                      // }
                    }),
              ],
            ),
            Visibility(
              visible: chosenRepeatCycle == RepeatCycle.other,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButton(
                      items: [2, 3, 4, 5, 6, 7, 8, 9, 10]
                          .map((int t) => DropdownMenuItem<int>(
                                child: Text(
                                  t.toString(),
                                ),
                                value: t,
                              ))
                          .toList(),
                      value: repeatFreq.num,
                      onChanged: (value) {
                        int x = repeatFreq.num;
                        if (value != null) {
                          repeatFreq.num = x;
                          setState(() {});
                        }
                      }),
                  const SizedBox(
                    width: 10,
                  ),
                  DropdownButton<Tenure>(
                    items: Tenure.values
                        .map((Tenure t) => DropdownMenuItem<Tenure>(
                              child: Text(
                                describeEnum(t),
                              ),
                              value: t,
                            ))
                        .toList(),
                    value: repeatFreq.tenure,
                    onChanged: (value) {
                      if (value != null) {
                        repeatFreq.tenure = value;
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Add to List",
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.values[1],
                  child: DropdownButton<String>(
                    isExpanded: true,
                    items: dropdownListCreator(listOptions),
                    onChanged: (String? chosenValue) {
                      // print(chosenValue);
                      // listOptions.add(listController.text);
                      if (chosenValue != null) {
                        setState(() {});
                        listController.text = "";
                        defaultOption = chosenValue;
                      }
                      // if (chosenValue != listOptions[0]) {
                      //   defaultOption = listOptions.last;
                      // }
                    },
                    value: listOptions.last == defaultOption
                        ? defaultOption
                        : listController.text,
                  ),
                ),
                Flexible(
                  flex: 0,
                  child: CustomIconButton(
                    iconData: Icons.create_new_folder_sharp,
                    onPressed: createDialog,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditableFieldWithCancelButton extends StatelessWidget {
  const EditableFieldWithCancelButton({
    Key? key,
    required this.hintText,
    required this.iconData,
    required this.textController,
    required this.picker,
    required this.onCancel,
    required this.enableCancelButton,
  }) : super(key: key);

  final String hintText;
  final IconData iconData;
  final TextEditingController textController;
  final void Function() picker;
  final void Function() onCancel;
  final bool Function() enableCancelButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 5),
        Flexible(
          child: TextField(
            controller: textController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
              isDense: true,
              hintText: hintText,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white60,
                ),
              ),
            ),
            onTap: picker,
            enableInteractiveSelection: false,
            showCursor: false,
            readOnly: true,
          ),
        ),
        const SizedBox(width: 5),
        CustomIconButton(
          iconData: iconData,
          onPressed: picker,
        ),
        Visibility(
            child: CustomIconButton(
              iconData: Icons.cancel_rounded,
              onPressed: onCancel,
            ),
            visible: enableCancelButton()),
      ],
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData iconData;
  final void Function() onPressed;

  const CustomIconButton({
    required this.iconData,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      autofocus: true,
      onPressed: onPressed,
      child: Icon(iconData),
      style: TextButton.styleFrom(
        primary: CupertinoColors.systemBlue,
        padding: const EdgeInsets.symmetric(horizontal: 9),
        tapTargetSize: MaterialTapTargetSize.padded,
        minimumSize: Size.zero,
      ),
    );
  }
}
*/
