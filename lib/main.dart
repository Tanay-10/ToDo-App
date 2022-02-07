import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/sqlite.dart';
import 'screens/new_task_screen.dart';
import 'screens/routing.dart' as routing;
import 'screens/home_screen.dart';
import 'package:todo/task.dart';
import 'package:todo/states/shared_data.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SqliteDB.initDb();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ToDoData(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
        // routes: {
        //   routing.newTaskScreenId: (context) => NewTaskScreen(),
        //   routing.homeScreenId: (context) => const MyHomePage(),
        // },
        onGenerateRoute: (settings) {
          var pageName = settings.name;
          var args = settings.arguments;
          if (pageName == routing.newTaskScreenId) {
            if (args is Task) {
              return MaterialPageRoute(
                  builder: (context) => NewTaskScreen(
                        task: args,
                      ));
            }
            return MaterialPageRoute(builder: (context) => NewTaskScreen());
          }
          if (pageName == routing.homeScreenId) {
            return MaterialPageRoute(builder: (context) => const MyHomePage());
          }
        },
      ),
    );
  }
}
