import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:todo/task.dart';
import 'routing.dart' as routing;
import 'package:todo/states/shared_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedListId = defaultListId;

  List<Widget> createSection(Section section, ToDoData todoData) {
    List<Task> tasks =
        todoData.fetchSection(selectedListId: selectedListId, section: section);
    if (tasks.isEmpty) return [];
    List<Widget> sectionWidgets = [];
    sectionWidgets.add(Text(describeEnum(section)));
    sectionWidgets.add(SizedBox(
      height: 8,
    ));
    for (var task in tasks) {
      sectionWidgets.add(ActivityCard(
        task: task,
        header: task.taskName,
        date: task.deadlineDate == null ? "" : task.deadlineDate.toString(),
        list: task.listId.toString(),
        onTap: () {
          Navigator.pushNamed(context, routing.newTaskScreenId,
              arguments: task);
        },
      ));
    }
    return sectionWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ToDoData>(builder: (context, todoData, x) {
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
          title: DropdownButton<int>(
            isExpanded: true,
            items: () {
              var activeLists = todoData.activeLists;
              List<DropdownMenuItem<int>> menuItems = [];
              for (var taskList in activeLists) {
                menuItems.add(
                  DropdownMenuItem<int>(
                    child: Text(taskList.listName),
                    value: taskList.listId,
                  ),
                );
              }
              return menuItems;
            }(),
            value: selectedListId,
            onChanged: (value) {
              selectedListId = value ?? selectedListId;
              setState(() {});
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app_sharp),
              onPressed: () async {
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, routing.socialSignInId, (route) => false);
              },
            )
          ],
        ),
        body: () {
          {
            if (todoData.isDataLoaded) {
              // var data = todoData.activeTasks;
              List<Widget> children = [];
              /*for (var task in data) {
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
              }*/
              for (var section in Section.values) {
                List<Widget> sectionWidget = createSection(section, todoData);
                children = [...children, ...sectionWidget];
              }
              return ListView(
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
                  onChanged: (value) {
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
