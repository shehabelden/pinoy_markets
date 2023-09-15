import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:morgancopy/presentation/home_page/main_page.dart';

import 'home_page/home_page.dart';
import 'sign_in/sign_in_view.dart';
import 'sign_in/sign_up.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    return StreamBuilder(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          print("auth.$snapshot");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            print(snapshot.data!);
            return MainPage();
          } else if (snapshot.hasError) {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      content: Text(snapshot.error.toString()),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("okay"))
                      ],
                    ));
          }
          return SignInView();
          // return const SignUp();
        });
  }
}
