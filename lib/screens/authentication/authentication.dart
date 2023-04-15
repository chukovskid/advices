import 'package:advices/App/providers/auth_provider.dart';
import 'package:advices/screens/authentication/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home/profile.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final AuthProvider _auth = AuthProvider();
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _auth.user.listen((user) {
      setState(() {
        isLoggedIn = user != null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return Profile();
    } else {
      return SignIn(
        toggleView: () {
          // You can leave this empty if you don't need any specific actions here.
        },
        fromAuth: true, // Add this line
      );
    }
  }
}
