import 'package:advices/config/agora.config.dart';
import 'package:advices/models/call.dart';
import 'package:advices/screens/lawyerProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../services/auth.dart';
import '../../services/database.dart';
import '../authentication/authentication.dart';

class Calls extends StatefulWidget {
  const Calls({
    Key? key,
  }) : super(key: key);

  @override
  State<Calls> createState() => _CallsState();
}

class _CallsState extends State<Calls>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController controller;
  final AuthService _auth = AuthService();
  User? user;
  @override
  void initState() {
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    // bool loggedIn = await _auth.isSignIn();
    user = await _auth.getCurrentUser();

    setState(() {
      user = user;
    });
    print(user?.uid);
    bool userExist = user != null ? true : false;
    if (!userExist) {
      _navigateToAuth();
    }
  }
  // @override
  // void dispose() {
  //   // Remove the observer
  //   WidgetsBinding.instance!.removeObserver(this);

  //   super.dispose();
  // }

  // }

  _navigateToAuth() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Authenticate()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(23, 34, 59, 1),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            textColor: Colors.white,
            icon: Icon(Icons.person_outline_sharp),
            label: Text(''),
            onPressed: _navigateToAuth,
          ),
        ],
      ),
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
        child: _cardsList(),
      ),
    );
  }

  Widget _cardsList() {
    return StreamBuilder<Iterable<Call>>(
      stream: DatabaseService.getOpenCallForUsers(user?.uid),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) return Text("loading data ...");
        if (snapshot.hasData) {
          final calls = snapshot.data!;
          return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 40.0,
              ),
              children: calls.map(_card).toList());
        } else {
          return Center(
            child: CircularProgressIndicator(
              value: controller.value,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              semanticsLabel: 'Linear progress indicator',
            ),
          );
        }
      }),
    );
  }

  Widget _card(Call call) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(call.channelName.toString()),
            subtitle:
                const Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LawyerProfile(call.channelName)),
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
