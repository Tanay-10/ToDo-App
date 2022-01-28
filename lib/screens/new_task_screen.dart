import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/todo.dart';
import 'package:intl/intl.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({Key? key}) : super(key: key);

  // void initState() {
  //   saveToSharedPref();
  //   super.initState();
  //   ToDoModel myTodo = ToDoModel(id: 1, title: "title", priority: 1);
  //   Map<String, dynamic>? map = myTodo.toMap();
  // }
  //
  // void saveToSharedPref() async {
  //   await instance.setString("1", "goto bed");
  //   String s = instance.getString("1")!;
  // }
  //
  // void dispose() {}

  @override
  _NewTaskScreenState createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  String themeTag = "white";

  DateTime? date = null;
  TimeOfDay? time = null;

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

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
      initialDate: date == null ? DateTime.now() : date!,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      date = pickedDate;
      setState(() {});
      var dateString = DateFormat('EEEE, d MMM, yyyy').format(pickedDate);
      dateController.text = dateString;
    }
  }

  void openTimePicker() async {
    print("opened the clock");
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: time == null ? TimeOfDay.now() : time!,
    );
    if (pickedTime != null) {
      time = pickedTime;
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
      title: Text(
        "Create new list",
        style: TextStyle(fontSize: 17),
      ),
      content: Flexible(
        child: TextField(
          controller: listController,
          decoration: InputDecoration(
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
            listOptions.add(listController.text);
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

  @override
  void initState() {
    saveToSharedPref();
    super.initState();
    ToDoModel myTodo = ToDoModel(
        id: 1,
        title: "title",
        priority: 1,
        category_id: 5,
        description: "abcd");
    Map<String, dynamic>? map = myTodo.toMap();
  }

  void saveToSharedPref() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    await instance.setString("1", "goto bed");
    String s = instance.getString("1")!;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: CupertinoColors.systemBlue,
          child: Icon(
            Icons.check,
            size: 30,
          ),
          onPressed: () {
            print("ToDo saved");
            Navigator.pop(context, true);
          }),
      appBar: AppBar(
        title: Text(
          "New Task",
          style: TextStyle(
            // color: (themeTag == "white") ? Colors.green : Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
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
                    decoration: InputDecoration(
                      hintText: "Enter Text Here",
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
            SizedBox(
              height: 30,
            ),
            Text(
              "Due Date",
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
                    onTap: openDatePicker,
                    readOnly: true,
                    controller: dateController,
                    decoration: InputDecoration(
                      hintText: "Select the due date",
                    ),
                    // textDirection: TextDirection.ltr,
                    textAlignVertical: TextAlignVertical.bottom,
                    autofocus: false,
                  ),
                ),
                CustomIconButton(
                  iconData: Icons.calendar_today_sharp,
                  onPressed: openDatePicker,
                ),
                Visibility(
                  visible: date == null ? false : true,
                  child: CustomIconButton(
                    iconData: Icons.cancel_rounded,
                    onPressed: () {
                      print("selected date removed");
                      date = null;
                      setState(() {});
                      dateController.text = "";
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 13,
            ),
            Visibility(
              visible: date == null ? false : true,
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      onTap: openTimePicker,
                      readOnly: true,
                      controller: timeController,
                      decoration: InputDecoration(
                        hintText: "Set time",
                      ),
                      // textDirection: TextDirection.ltr,
                      textAlignVertical: TextAlignVertical.bottom,
                      autofocus: false,
                    ),
                  ),
                  CustomIconButton(
                    iconData: Icons.watch_later_outlined,
                    onPressed: openTimePicker,
                  ),
                  Visibility(
                    visible: time == null ? false : true,
                    child: CustomIconButton(
                      iconData: Icons.cancel_rounded,
                      onPressed: () {
                        print("selected time removed");
                        time = null;
                        setState(() {});
                        timeController.text = "";
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 80,
            ),
            Text("Repeat"),
            DropdownButton<String>(
              items: dropdownItemCreator(dropdownOptions),
              value: selectedFrequency,
              onChanged: (String? chosenValue) {
                // print(chosenValue);
                if (chosenValue != null) {
                  if (chosenValue != dropdownOptions.last) {
                    selectedFrequency = chosenValue;
                    setState(() {});
                  } else {
                    AlertDialog alert = AlertDialog(
                      title: Text(
                        "Repeat",
                        style: TextStyle(fontSize: 17),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text("Set"),
                        )
                      ],
                      content: CupertinoPicker(
                        magnification: 1.2,
                        children: repeatSpan
                            .map((item) => Center(
                                  child: Text(item),
                                ))
                            .toList(),
                        onSelectedItemChanged: (index) {
                          print(index);
                        },
                        itemExtent: 60.0,
                      ),
                      elevation: 100.0,
                    );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                      // barrierDismissible: false,
                    );
                  }
                }
              },
            ),
            SizedBox(
              height: 50,
            ),
            Text("Add to List"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
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
                CustomIconButton(
                  iconData: Icons.create_new_folder_sharp,
                  onPressed: createDialog,
                ),
              ],
            ),
          ],
        ),
      ),
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
