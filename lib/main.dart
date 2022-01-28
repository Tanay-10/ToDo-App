import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'screens/new_task_screen.dart';
import 'screens/routing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: {
        newTaskScreenId: (context) {
          return const NewTaskScreen();
        },
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  //var square = (int value){};

  // square(int value){
  //   print(value*value);
  // }

  // void onPressedFunc() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: CupertinoColors.systemBlue,
          elevation: 1.0,
          hoverElevation: 10.0,
          child: Icon(
            Icons.add,
            size: 50,
          ),
          // child: Text("Click"),
          onPressed: () {
            print("clicked");
            Navigator.pushNamed(context, newTaskScreenId);
          }),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("ToDo"),
      ),
      body: Container(
          // color: Colors.blueAccent,
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Scrollbar(
            isAlwaysShown: true,
            showTrackOnHover: true,
            hoverThickness: 10,
            thickness: 10,
            radius: Radius.circular(10),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                Container(
                  child: Text(
                    "Overdue",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.indigo.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(7, 10, 0, 10),
                ),
                const ActivityCard(
                  header: "Pay fees",
                  date: "30th Jan",
                  list: "Academia",
                ),
                const ActivityCard(
                  header: "Pay bill",
                  date: "25th Jan",
                  list: "Household",
                ),
                const ActivityCard(
                  header: "Recharge",
                  date: "22nd Jan",
                  list: "Personal",
                ),
                const ActivityCard(
                  header: "Recharge",
                  date: "22nd Jan",
                  list: "Personal",
                ),
                const ActivityCard(
                  header: "Recharge",
                  date: "22nd Jan",
                  list: "Personal",
                ),
                const ActivityCard(
                  header: "Recharge",
                  date: "22nd Jan",
                  list: "Personal",
                ),
                const ActivityCard(
                  header: "Recharge",
                  date: "22nd Jan",
                  list: "Personal",
                ),
                const ActivityCard(
                  header: "Recharge",
                  date: "22nd Jan",
                  list: "Personal",
                ),
                const ActivityCard(
                  header: "Recharge",
                  date: "22nd Jan",
                  list: "Personal",
                ),
                const ActivityCard(
                  header: "Recharge",
                  date: "22nd Jan",
                  list: "Personal",
                ),
                // SizedBox(
                //   height: 8,
                // ),
              ],
            ),
          )),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String header, date, list;

  const ActivityCard({
    required this.header,
    required this.date,
    required this.list,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
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
                SizedBox(
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
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      list,
                      style: TextStyle(
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
        SizedBox(
          height: 6,
        )
      ],
    );
  }
}
