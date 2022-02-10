import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/screens/splash_screen.dart';
import 'datastore/sqlite.dart';
import 'screens/new_task_screen.dart';
import 'screens/routing.dart' as routing;
import 'screens/home_screen.dart';
import 'screens/social_sign_in_screen.dart';
import 'package:todo/task.dart';
import 'package:todo/states/shared_data.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
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
        // home: const MyHomePage(),
        initialRoute: routing.splashScreenId,
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
          if (pageName == routing.socialSignInId) {
            return MaterialPageRoute(
                builder: (context) => const SocialSignIn());
          }
          if (pageName == routing.splashScreenId) {
            return MaterialPageRoute(
                builder: (context) => const SplashScreen());
          }
        },
      ),
    );
  }
}
