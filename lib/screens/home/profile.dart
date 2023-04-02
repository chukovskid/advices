// ignore_for_file: deprecated_member_use

import 'package:advices/App/models/user.dart';
import 'package:advices/App/providers/auth_provider.dart';
import 'package:advices/App/services/googleAuth.dart';
import 'package:advices/screens/authentication/sign_in.dart';
import 'package:advices/screens/shared_widgets/base_app_bar.dart';
import 'package:advices/assets/utilities/constants.dart';
import 'package:flutter/material.dart';
import '../authentication/authentication.dart';

class Profile extends StatefulWidget {
  final Function? toggleView;
  Profile({this.toggleView});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthProvider _auth = AuthProvider();
  FlutterUser? _fireUser;
  var imageUrl =
      "https://devshift.biz/wp-content/uploads/2017/04/profile-icon-png-898.png"; //you can use a image
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
        imageUrl = (user.photoURL.isEmpty ? imageUrl : user.photoURL);
      });
    }

    return user;
  }

  void goBack() {
    Navigator.pop(context);
  }

  _navigateToAuthenticate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Authenticate()),
    );
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    // bool isSignIn = await _auth.googleIsSignIn();
    await GoogleAuthService.signOutWithGoogle(context: context);
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignIn()),
    );
    // return isSignIn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(appBar: AppBar(), redirectToHome: true),
      backgroundColor: Color.fromARGB(255, 226, 146, 100),
      body: Container(
          height: double.maxFinite,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: backgroundColor,
              stops: [-1, 1, 2],
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
          borderRadius: BorderRadius.circular(4),
        ),
        child: Container(
          width:
              MediaQuery.of(context).size.width > 500 ? 500 : double.infinity,
          margin: const EdgeInsets.all(10),
          child: Center(
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
                ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black)),
                    // color: Color.fromRGBO(23, 34, 59, 1),
                    child: const Text(
                      'Sign out',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      await _signOut();
                    }),
              ],
            ),
          ),
        ));
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
