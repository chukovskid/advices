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
  bool showSignIn = true;
  bool isLoggedIn = true;
  @override
  void initState() {
    super.initState();
    toggleView();
  }

  Future<void> toggleView() async {
    // bool loggedIn = await _auth.isSignIn();
    User? user = await _auth.getCurrentUser();
    bool userExist = user != null? true : false;
    setState(() => {showSignIn = !showSignIn, isLoggedIn = userExist});
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return Profile();
    } else {
        return SignIn(toggleView: toggleView);
    }
  }
}
