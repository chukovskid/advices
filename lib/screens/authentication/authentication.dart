import 'package:advices/App/providers/auth_provider.dart';
import 'package:advices/screens/authentication/lawyerBasedRedirect.dart';
import 'package:advices/screens/authentication/sign_in.dart';
import 'package:advices/screens/profile/lawyerProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../App/models/user.dart';
import '../home/profile.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
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
      return LawyerBasedRedirect(
          lawyerWidget: LawyerProfile(loggedUser.uid, "serviceId"),
          nonLawyerWidget: Profile());
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
