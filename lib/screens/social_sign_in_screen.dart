import 'package:flutter/material.dart';
import 'routing.dart' as routing;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SocialSignIn extends StatefulWidget {
  const SocialSignIn({Key? key}) : super(key: key);

  @override
  _SocialSignInState createState() => _SocialSignInState();
}

class _SocialSignInState extends State<SocialSignIn> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    var x = auth.currentUser;
                    if (x != null) {
                      print(x.email);
                    } else {
                      print("user not signed in");
                    }
                  },
                  child: Text("Current user state"),
                ),
                TextButton(
                  child: Text("Log out"),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                ),
                TextButton(
                  child: Text("Social Sign Up"),
                  onPressed: () async {
                    // final GoogleSignInAccount? googleUser =
                    //     await GoogleSignIn().signIn();
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                        email: "tanay4915@gmail.com",
                        password: "abcd@1234",
                      );
                    } on FirebaseAuthException catch (e) {
                      if (e.code == "weak-password") {
                        print("the password provided is too weak");
                      } else if (e.code == "email-already-in-use") {
                        print("email already in use");
                      } else {
                        print(e.code);
                      }
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
