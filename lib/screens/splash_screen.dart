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

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    // super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await Firebase.initializeApp();
      await SqliteDB.initDb();
      FirebaseAuth auth = FirebaseAuth.instance;
      if (auth.currentUser != null) {
        Provider.of<ToDoData>(context, listen: false).init();
        Navigator.pushNamedAndRemoveUntil(
            context, routing.homeScreenId, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, routing.socialSignInId, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Welcome"),
    );
  }
}
