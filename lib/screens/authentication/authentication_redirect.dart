import 'package:advices/App/providers/auth_provider.dart';
import 'package:advices/screens/authentication/sign_in.dart';
import 'package:flutter/material.dart';

import '../../App/models/user.dart';

class AuthRedirect extends StatefulWidget {
  final Widget authenticatedWidget;
  
  AuthRedirect({required this.authenticatedWidget});

  @override
  _AuthRedirectState createState() => _AuthRedirectState();
}

class _AuthRedirectState extends State<AuthRedirect> {
  final AuthProvider _auth = AuthProvider();
  bool isLoggedIn = false;
  FlutterUser loggedUser = FlutterUser();

  @override
  void initState() {
    super.initState();
    _auth.user.listen((user) {
      setState(() {
        isLoggedIn = user != null;
      });
      if (user != null) {
        loggedUser = FlutterUser(
          email: user.email,
          uid: user.uid,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return widget.authenticatedWidget; // Show the passed widget when user is authenticated
    } else {
      return SignIn(
        toggleView: () {
          // You can leave this empty if you don't need any specific actions here.
        },
        // fromAuth: true, // Add this line
      );
    }
  }
}
