import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo/states/shared_data.dart';
import 'routing.dart' as routing;
import 'package:todo/datastore/sqlite.dart';
import 'home_screen.dart';
import 'social_sign_in_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

Future<int> initialization() async {
  await Firebase.initializeApp();
  await SqliteDB.initDb();
  // await Future.delayed(Duration(seconds: 10));
  return 1;
}

class _SplashScreenState extends State<SplashScreen> {
  Future<int> init = initialization();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: init,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          FirebaseAuth auth = FirebaseAuth.instance;
          if (auth.currentUser == null) {
            Provider.of<ToDoData>(context, listen: false).init();
            return SocialSignIn();
          } else {
            return MyHomePage();
          }
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error"),
          );
        } else
          return Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }
}
