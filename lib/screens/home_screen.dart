import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo/task.dart';
import 'routing.dart' as routing;
import 'package:todo/database/sqlite.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Task>> taskList = SqliteDB.getAllTasks();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: CupertinoColors.systemBlue,
          elevation: 1.0,
          hoverElevation: 10.0,
          child: const Icon(
            Icons.add,
            size: 50,
          ),
          onPressed: () {
            print("clicked");
            Navigator.pushNamed(context, routing.newTaskScreenId,
                arguments: Task);
          }),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("ToDo"),
      ),
      body:
          // Column(
          //   children: [
          //     Container(
          //       child: Text("Hello"),
          //     ),
          FutureBuilder<List<Task>>(
              future: taskList,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data;
                  List<Widget> children = [];
                  children.add(Container(
                    child: const Center(
                      child: Text(
                        "Overdue",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                    ),
                  ));
                  for (var task in data) {
                    print("FutureBuilder");
                    children.add(
                      ActivityCard(
                          header: task.taskName,
                          date: task.deadlineDate == null
                              ? ""
                              : task.deadlineDate.toString(),
                          list: task.taskListId.toString(),
                          onTap: () {
                            Navigator.pushNamed(
                                context, routing.newTaskScreenId,
                                arguments: task);
                          }),
                    );
                  }
                  return ListView(
                    // scrollDirection: Axis.vertical,
                    children: children,
                    padding: const EdgeInsets.all(5),
                  );
                } else if (snapshot.hasError) {
                  // print(snapshot.hasError);
                  return const Text("Some error");
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
      // ],
      // ),
      // Container(
      //   // color: Colors.blueAccent,
      //   padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      // child: Scrollbar(
      //   isAlwaysShown: true,
      //   showTrackOnHover: true,
      //   hoverThickness: 10,
      //   thickness: 10,
      //   radius: Radius.circular(10),
      //   child: ListView(
      //     scrollDirection: Axis.vertical,
      //     children: [
      //       Container(
      //         child: Text(
      //           "Overdue",
      //           style: TextStyle(
      //             fontSize: 18,
      //             color: Colors.indigo.shade900,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //         padding: EdgeInsets.fromLTRB(7, 10, 0, 10),
      //       ),
      //        ])
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String header, date, list;
  final void Function() onTap;

  const ActivityCard({
    required this.header,
    required this.date,
    required this.list,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
                height: 25,
                child: Checkbox(
                  value: false,
                  onChanged: (value) {
                    print("task finished");
                  },
                  autofocus: true,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    header,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    date,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    list,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        color: Colors.teal,
      ),
    );
  }
}
