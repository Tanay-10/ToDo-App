import 'package:flutter/material.dart';
import 'database/sqlite.dart';
import 'screens/new_task_screen.dart';
import 'screens/routing.dart' as routing;
import 'screens/home_screen.dart';
import 'task.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SqliteDB.initDb();
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
    );
  }
}
