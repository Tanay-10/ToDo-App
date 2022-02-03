import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:todo/task.dart';
import 'routing.dart' as routing;
import 'package:todo/shared_data.dart';
import 'package:todo/database/sqlite.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ToDoData>(builder: (context, sd, x) {
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
              Navigator.pushNamed(
                context,
                routing.newTaskScreenId, /* arguments: Task*/
              );
            }),
        appBar: AppBar(
          // backgroundColor: Colors.blue,
          title: Text("ToDo"),
        ),
        body: () {
          {
            if (sd.isDataLoaded) {
              var data = sd.activeTasks;
              List<Widget> children = [];
              for (var task in data) {
                children.add(
                  ActivityCard(
                      task: task,
                      header: task.taskName,
                      date: task.deadlineDate == null
                          ? ""
                          : task.deadlineDate.toString(),
                      list: task.listId.toString(),
                      onTap: () {
                        Navigator.pushNamed(context, routing.newTaskScreenId,
                            arguments: task);
                      }),
                );
              }
              return ListView(
                // scrollDirection: Axis.vertical,
                children: children,
                padding: const EdgeInsets.all(5),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        }(),
      );
    });
  }
}

class ActivityCard extends StatelessWidget {
  final Task task;
  final String header, date, list;
  final void Function() onTap;

  const ActivityCard({
    required this.task,
    required this.header,
    required this.date,
    required this.list,
    required this.onTap,
    // required this.isFinished,
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
                  onChanged: (value) async {
                    Provider.of<ToDoData>(context, listen: false)
                        .finishTask(task);
                  },
                  value: false,
                  // autofocus: true,
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
                    style: TextStyle(
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
