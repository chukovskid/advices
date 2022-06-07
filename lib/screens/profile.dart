// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:advices/models/user.dart';
import 'package:advices/screens/authentication/register.dart';
import 'package:advices/screens/authentication/sign_in.dart';
import 'package:advices/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../services/auth.dart';
import '../services/database.dart';
import 'authentication/authentication.dart';

class Profile extends StatefulWidget {
  final Function? toggleView;
  Profile({this.toggleView});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  FlutterUser? _fireUser;
  var imageUrl = "https://devshift.biz/wp-content/uploads/2017/04/profile-icon-png-898.png"; //you can use a image
  final double circleRadius = 105.0;
  final double circleBorderWidth = 3.0;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  getCurrentUser() async {
    FlutterUser? user = await _auth.getMyProfileInfo();
    print(user?.uid);
    if (user != null) {
      setState(() {
        _fireUser = user;
        imageUrl = (user.photoURL.isEmpty ? imageUrl : user.photoURL );
      });
    }

    return user;
  }

  void goBack() {
    Navigator.pop(context);
  }

  _navigateToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  _navigateToAuthenticate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Authenticate()),
    );
  }


  Future<bool> _signOut() async {
    await _auth.signOut();
    bool isSignIn = await _auth.googleIsSignIn();
    return isSignIn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Color.fromRGBO(23, 34, 59, 1),
        backgroundColor: Color.fromRGBO(23, 34, 59, 1),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            textColor: Colors.white,
            icon: Icon(Icons.home),
            label: Text(''),
            onPressed: _navigateToHome,
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 226, 146, 100),
      body: Container(
          height: double.maxFinite,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(107, 119, 141, 1),
                Color.fromRGBO(38, 56, 89, 1),
              ],
              stops: [-1, 2],
            ),
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: circleRadius / 1.5),
                  child: _info()),
              Container(
                margin: const EdgeInsets.only(top: 30),
                width: circleRadius,
                height: circleRadius,
                decoration: const ShapeDecoration(
                  shape: CircleBorder(),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.all(circleBorderWidth),
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                        shape: CircleBorder(),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              imageUrl,
                            ))),
                  ),
                ),
              )
            ],
          )),
    );
  }

  Widget _info() {
    return Card(
      elevation: 0.3,
      margin: const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        width: double.infinity / 0.2,
        // margin: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "  ${_fireUser?.displayName}",
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Color.fromRGBO(23, 34, 59, 1),
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 20.0),
            RichText(
              text: TextSpan(children: [
                const WidgetSpan(
                  child: Icon(Icons.phone, size: 14),
                ),
                TextSpan(
                  text: "  ${_fireUser?.email}",
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Color.fromRGBO(23, 34, 59, 1),
                    fontSize: 18,
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 20.0),
            RichText(
              text: TextSpan(children: [
                const WidgetSpan(
                  child: Icon(Icons.web, size: 14),
                ),
                TextSpan(
                  text: "  ${_fireUser?.phoneNumber}",
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Color.fromRGBO(23, 34, 59, 1),
                    fontSize: 18,
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 20.0),
            RichText(
              text: TextSpan(children: [
                const WidgetSpan(
                  child: Icon(Icons.email, size: 14),
                ),
                TextSpan(
                  text: "  ${_fireUser?.uid}",
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Color.fromRGBO(23, 34, 59, 1),
                    fontSize: 12,
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 40.0),
            RaisedButton(
                color: Color.fromRGBO(23, 34, 59, 1),
                child: const Text(
                  'Sign out',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  await _signOut();
                  var isSignIn = await _auth.getCurrentUser();
                  isSignIn != null
                      ? _showToast(context, "Something went wrong")
                      : {
                          _showToast(context, "You are logged out"),
                          _navigateToAuthenticate()
                        };
                }),
          ],
        ),
      ),
    );
  }

  void _showToast(BuildContext context, String text) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text('$text'),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
