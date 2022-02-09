import 'package:flutter/material.dart';
import 'routing.dart' as routing;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/states/shared_data.dart';
import 'package:provider/provider.dart';

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
                  child: Text(
                    "Google Sign In",
                  ),
                  onPressed: () async {
                    try {
                      final GoogleSignInAccount? googleUser =
                          await GoogleSignIn().signIn();
                      final GoogleSignInAuthentication? googleAuth =
                          await googleUser?.authentication;

                      /// Create a new credential
                      final credential = GoogleAuthProvider.credential(
                        accessToken: googleAuth!.accessToken,
                        idToken: googleAuth.idToken,
                      );

                      /// Once signed in, return the UserCredential
                      await FirebaseAuth.instance
                          .signInWithCredential(credential);
                      Provider.of<ToDoData>(context, listen: false).init();
                      Navigator.pushNamedAndRemoveUntil(
                          context, routing.homeScreenId, (route) => false);
                    } catch (e) {
                      print(e);
                    }
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
